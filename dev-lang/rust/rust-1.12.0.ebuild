# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 versionator toolchain-funcs

ABI_VER="$(get_version_component_range 1-2)"
SLOT="beta/${ABI_VER}"
MY_P="rustc-beta"
SRC="${MY_P}-src.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz
	 !local-rust? ( amd64? ( https://alpine.geeknet.cz/distfiles/rustc-1.10.0-x86_64-unknown-linux-musl.tar.gz
		               https://alpine.geeknet.cz/distfiles/rust-std-1.10.0-x86_64-unknown-linux-musl.tar.gz ) )
"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang debug doc +libcxx +system-llvm +local-rust +source"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
	system-llvm? ( >=sys-devel/llvm-3.7.1-r1:=
		<sys-devel/llvm-3.10.0:= )
	local-rust? ( >dev-lang/rust-1.10.0 )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
"

PDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default
}

src_prepare() {
	find mk -name '*.mk' -exec \
		 sed -i -e "s/-Werror / /g" {} \; || die

	eapply "${FILESDIR}"/use-system-libs.patch
	eapply "${FILESDIR}"/remove-compiler-rt.patch
	eapply "${FILESDIR}"/llvm-ffi.patch

	if ! use local-rust; then
		mkdir ${S}/stage0

		cp -flr "${WORKDIR}"/rustc-*/rustc/* \
			"${WORKDIR}"/rust-std-*/rust-std-*/* \
			"${S}/stage0"/
	fi

	eapply_user
}

src_configure() {
	export CFG_DISABLE_LDCONFIG="notempty"

	if use local-rust; then
		local rustc_ver="$(/usr/bin/rustc --version | cut -f2 -d ' ')"

		if [[ "${PV}" == "{rustc_ver" ]] ; then
			local rustc_key="$(printf "$rustc_ver" | md5sum | cut -c1-8)"
			sed -Ei \
				-e "s/^(rustc):.*/\1: $rustc_ver-1970-01-01/" \
				-e "s/^(rustc_key):.*/\1: $rustc_key/" \
				src/stage0.txt
		fi
	fi

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
		--enable-local-rust \
		--disable-jemalloc \
		$(use_enable clang) \
		$(use_enable debug) \
		$(use_enable debug llvm-assertions) \
		$(use_enable !debug optimize) \
		$(use_enable !debug optimize-cxx) \
		$(use_enable !debug optimize-llvm) \
		$(use_enable !debug optimize-tests) \
		$(use_enable doc docs) \
		$(use_enable libcxx libcpp) \
		$(usex system-llvm "--llvm-root=${EPREFIX}/usr" " ") \
		$(usex local-rust "--local-rust-root=${EPREFIX}/usr/bin" "--local-rust-root=${S}/stage0") \
		|| die
}

src_compile() {
	if use local-rust; then
		emake RUSTFLAGS_STAGE0="-Lx86_64-unknown-linux-gnu/stage0/lib/rustlib/x86_64-unknown-linux-gnu/lib" VERBOSE=1
	else
		emake VERBOSE=1
	fi
}

src_install() {
	unset SUDO_USER

	default

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
		mkdir -p ${D}/usr/src/${P}/
		find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/src/${P}/ \; || die
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
		elog "install app-vim/rust-mode to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
