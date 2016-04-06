# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-any-r1

MY_P="rustc-${PV}"
MY_RUST="1.8.0-stage0-snapshot.zip"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="https://github.com/rust-lang/rust/archive/4d3eebff9dc9474f56cdba810edde324130fbc61.zip -> rust-${MY_RUST}
         https://github.com/rust-lang/rust-installer/archive/c37d3747da75c280237dc2d6b925078e69555499.zip -> rust-installer-${MY_RUST}
         https://github.com/rust-lang/libc/archive/a64ee24718c0289b82a77d692cf56f8a1226de51.zip -> rust-libc-${MY_RUST}
         https://github.com/rust-lang/compiler-rt/archive/b6087e82ba1384c4af3adf2dc68e92316f0d4caf.zip -> rust-compiler_rt-${MY_RUST}
	 https://github.com/rust-lang/hoedown/archive/4638c60dedfa581fd5fa7c6420d8f32274c9ca0b.zip -> rust-hoedown-${MY_RUST}
	 amd64? ( http://static.rust-lang.org/stage0-snapshots/rust-stage0-2015-12-18-3391630-linux-x86_64-97e2a5eb8904962df8596e95d6e5d9b574d73bf4.tar.bz2 )
	 x86?   ( http://static.rust-lang.org/stage0-snapshots/rust-stage0-2015-12-18-3391630-linux-i386-a09c4a4036151d0cb28e265101669731600e01f2.tar.bz2 )"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="nightly"
KEYWORDS="~amd64 ~x86"

IUSE="+clang debug doc +libcxx +system-llvm"
REQUIRED_USE="libcxx? ( clang )"

CDEPEND="libcxx? ( sys-libs/libcxx )
	>=app-eselect/eselect-rust-0.3_pre20150425
"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
	system-llvm? ( >=sys-devel/llvm-3.7.0 )
"
RDEPEND="${CDEPEND}
"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack rust-${MY_RUST}
	mv rust* ${MY_P}

	mkdir "${MY_P}/dl" || die
	cp "${DISTDIR}/rust-stage0"* "${MY_P}/dl/" || die

	unpack rust-installer-${MY_RUST}
	mv rust-installer*/* ${MY_P}/src/rust-installer/

	unpack rust-libc-${MY_RUST}
	mv libc*/* ${MY_P}/src/liblibc/

	unpack rust-compiler_rt-${MY_RUST}
	mv compiler-rt*/* ${MY_P}/src/compiler-rt/

	unpack rust-hoedown-${MY_RUST}
	mv hoedown*/* ${MY_P}/src/rt/hoedown/
}

src_prepare() {
	local postfix="gentoo-${SLOT}"
	sed -i -e "s/CFG_FILENAME_EXTRA=.*/CFG_FILENAME_EXTRA=${postfix}/" mk/main.mk || die
	find mk -name '*.mk' -exec \
		 sed -i -e "s/-Werror / /g" {} \; || die
#	epatch ${FILESDIR}/llvm-3.8.patch
	epatch ${FILESDIR}/remove-gcc-personality.patch
}

src_configure() {
	export CFG_DISABLE_LDCONFIG="notempty"
	"${ECONF_SOURCE:-.}"/configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)/${P}" \
		--mandir="${EPREFIX}/usr/share/${P}/man" \
		--release-channel=${SLOT} \
		--disable-manage-submodules \
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
	emake snap-stage3 VERBOSE=1
}

src_install() {
	default

	mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
	mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
	mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die

	dodoc COPYRIGHT LICENSE-APACHE LICENSE-MIT

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

	mkdir -p "${D}"/usr/src/rust-${PV}
        cp -r src/lib* "${D}"/usr/src/rust-${PV}/
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
