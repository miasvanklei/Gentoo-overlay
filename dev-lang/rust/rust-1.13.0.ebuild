# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 versionator toolchain-funcs

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.gz"
	KEYWORDS=""
else
	ABI_VER="$(get_version_component_range 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.gz"
	KEYWORDS="~amd64"
fi

STAGE0_VERSION="1.$(($(get_version_component_range 2) - 1)).0"
RUST_STAGE0_amd64="rustc-${STAGE0_VERSION}-x86_64-unknown-linux-gnu"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang debug doc +libcxx +source +system-llvm"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
	system-llvm? ( >=sys-devel/llvm-3.8.1-r2:=
		<sys-devel/llvm-3.10.0:= )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
"

PDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find mk -name '*.mk' -exec \
		 sed -i -e "s/-Werror / /g" {} \; || die

	if use elibc_musl; then
		cat > config.toml <<EOF
[build]
cargo = "/usr/bin/cargo"
rustc = "/usr/bin/rustc"
EOF
		sed -i /LD_LIBRARY_PATH/d src/bootstrap/bootstrap.py

		eapply "${FILESDIR}"/link-musl-dynamically.patch
		eapply "${FILESDIR}"/libunwind-shared.patch
		eapply "${FILESDIR}"/no-compiler-rt.patch
		eapply "${FILESDIR}"/dont-use-no_default_libraries.patch
		eapply "${FILESDIR}"/dont-install-crtfiles.patch
	fi

	eapply "${FILESDIR}"/link-llvm-static.patch
	eapply "${FILESDIR}"/llvm-with-ffi.patch
	eapply "${FILESDIR}"/link-with-libcxx.patch
	eapply "${FILESDIR}"/do-not-strip-when-debug.patch

	# llvm 4.0
	eapply "${FILESDIR}"/allow-llvm-4.0.patch
	eapply "${FILESDIR}"/TwineRef-to-char.patch
	eapply "${FILESDIR}"/set-EH-personality.patch
	eapply "${FILESDIR}"/legacy-pass.patch
	eapply "${FILESDIR}"/new-error-reporting.patch
	eapply "${FILESDIR}"/outdated-stuff.patch
	eapply "${FILESDIR}"/remove-DIDescriptorFlags.patch
	eapply "${FILESDIR}"/cannot-cast-like-this.patch
	eapply "${FILESDIR}"/some-fixes.patch
	eapply "${FILESDIR}"/disable-target-feature-listing-support.patch
	eapply "${FILESDIR}"/compile-without-debug.patch
	eapply "${FILESDIR}"/split-header.patch

	eapply_user
}

src_configure() {
	export CFG_DISABLE_LDCONFIG="notempty"
	export CARGO_HOME="${S}/.cargo"

	local target
	case ${CHOST} in
		x86_64-*musl) target=x86_64-unknown-linux-musl;;
		x86_64-*gnu) target=x86_64-unknown-linux-gnu;;
	esac

	"${ECONF_SOURCE:-.}"/configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)/${P}" \
		--mandir="${EPREFIX}/usr/share/${P}/man" \
		--release-channel=${SLOT%%/*} \
		--disable-manage-submodules \
		--default-linker=$(tc-getBUILD_CC) \
		--default-ar=$(tc-getBUILD_AR) \
		--python=${EPYTHON} \
		--disable-rpath \
		--host=${target} \
		--build=${target} \
		--enable-rustbuild \
		--enable-local-rust \
		$(use_enable clang) \
		$(use_enable debug) \
		$(use_enable debug llvm-assertions) \
		$(use_enable !debug optimize) \
		$(use_enable !debug optimize-cxx) \
		$(use_enable !debug optimize-llvm) \
		$(use_enable !debug optimize-tests) \
		$(use_enable doc docs) \
		$(use_enable !elibc_musl jemalloc) \
		$(use_enable libcxx libcpp) \
		$(usex system-llvm "--llvm-root=${EPREFIX}/usr" " ") \
		$(usex elibc_musl "--musl-root=${EPREFIX}/usr" " ") \
		|| die
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	emake dist VERBOSE=1
	unset SUDO_USER

	mkdir -p "${D}/usr"

	tar xf build/dist/rustc-*-*-*.tar.gz -C "${D}/usr" --strip-components=2 --exclude=manifest.in || die
	tar xf build/dist/rust-std-*-*-*.tar.gz -C "${D}/usr/lib" --strip-components=3 --exclude=manifest.in || die

	pushd ${D}/usr/lib || die

	# symlinks instead of copies
	ln -sf rustlib/*/lib/*.so . || die

	popd >/dev/null

	mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
	mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
	mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die

	dodoc COPYRIGHT

	dodir "/usr/share/doc/rust-${PV}/"
	mv "${D}/usr/share/doc/rust"/* "${D}/usr/share/doc/rust-${PV}/" || die
	rmdir "${D}/usr/share/doc/rust/" || die

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/usr/$(get_libdir)/${P}"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	EOF
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"

	if use source; then
		pushd ${S}/src
		mkdir -p ${D}/usr/src/${P}
		find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/src/${P} \; || die
		popd >/dev/null
	fi
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-${PV}."

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
