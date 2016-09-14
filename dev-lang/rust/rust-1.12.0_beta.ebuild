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

STAGE0_VERSION="1.$(($(get_version_component_range 2) - 1)).0"
NEXT_VERSION="1.$(($(get_version_component_range 2) + 1)).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang debug doc +libcxx +system-llvm +source"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
	system-llvm? ( >=sys-devel/llvm-3.7.1-r1:=
		<sys-devel/llvm-3.10.0:= )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
	|| (
		( >=dev-lang/rust-bin-${STAGE0_VERSION}:stable
		  <dev-lang/rust-bin-${NEXT_VERSION}:stable )
		( >=dev-lang/rust-${STAGE0_VERSION}:stable
		  <dev-lang/rust-${NEXT_VERSION}:stable )
		( =dev-lang/${P} )
	)
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
	eapply "${FILESDIR}"/rust-1.11.0-libdir-bootstrap.patch

	eapply_user
}

src_configure() {
	local local_rebuild
	local installed_version="$("${EPREFIX}/usr/bin/rustc" --version)" || die
	local fixed_installed_version="${installed_version//-/_}"
	case "${fixed_installed_version}" in
		"rustc ${PV}.2") local_rebuild=--enable-local-rebuild ;;
		"rustc-${STAGE0_VERSION}") ;;
		*)
			eerror "Selected rust (${fixed_installed_version}) cannot build"
			eerror "version ${PV}.  Please use version ${STAGE0_VERSION}"
			eerror "or ${PV}."
			die "Incompatible rust selected"
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
		--enable-local-rust \
		--local-rust-root="${EPREFIX}/usr" \
		${local_rebuild} \
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
		|| die
}

src_compile() {
	emake VERBOSE=1
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
