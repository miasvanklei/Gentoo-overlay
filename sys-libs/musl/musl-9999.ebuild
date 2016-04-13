# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs multilib-minimal pax-utils git-r3

EGIT_REPO_URI="git://git.musl-libc.org/musl"

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="+compat"

RDEPEND="!sys-apps/getent
	 compat? ( sys-libs/bsd-compat
		   sys-libs/argp-standalone
		   sys-libs/musl-obstack
		   sys-libs/musl-fts )"

src_prepare() {
	epatch "${FILESDIR}"/kernel.patch
	epatch "${FILESDIR}"/musl-add-gnu-symbols.patch
	epatch "${FILESDIR}"/printf.patch
	epatch "${FILESDIR}"/glibc-abi-compat.patch
	epatch "${FILESDIR}"/qsort_r.patch
	epatch "${FILESDIR}"/ptrace.patch
	epatch "${FILESDIR}"/mallinfo.patch
	epatch "${FILESDIR}"/context.patch
	epatch "${FILESDIR}"/pthread-try-timed.patch
#	epatch "${FILESDIR}"/no-utf8-code-units-locale.patch
	epatch "${FILESDIR}"/multilib.patch
	epatch "${FILESDIR}"/backtrace.patch
	epatch "${FILESDIR}"/use-defines-instead-of-function.patch
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
        econf \
	--syslibdir=/$(get_libdir) \
	--libdir=/usr/$(get_libdir) \
	--disable-gcc-wrapper
}

multilib_src_compile() {
	emake || die
}

multilib_src_install() {

	MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bits/*
	)

	emake DESTDIR="${D}" install || die


	# musl provides ldd through its linker
	local ldso=$(basename "${D}"/$(get_libdir)/ld-musl-*)


	# move symlinks around and create linkerscript to directly link with libc.so
        mv -f "${D}"/usr/$(get_libdir)/libc.so "${D}"/$(get_libdir)/${ldso}
        gen_usr_ldscript ${ldso}
        mv "${D}"/usr/$(get_libdir)/${ldso} "${D}"/usr/$(get_libdir)/libc.so

	dosym /$(get_libdir)/${ldso} /usr/bin/${CHOST}-ldd
	ar rcs ${D}/usr/$(get_libdir)/libintl.a || die

	# needed for ldd under pax kernel
	pax-mark r "${D}"/lib64/${ldso}

}

multilib_src_install_all() {
	local ldso=$(basename "${D}"/$(get_libdir)/ld-musl-*)
	local i
        for i in getconf getent iconv; do
		${CC} ${CFLAGS} "${FILESDIR}"/$i.c -o $i
		dobin $i
        done
	dosym /$(get_libdir)/${ldso} /usr/bin/ldd
	insinto /sbin
	doins ${FILESDIR}/ldconfig
	chmod +x "${D}"/sbin/ldconfig
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	# reload init ...
	/sbin/telinit U 2>/dev/null
}
