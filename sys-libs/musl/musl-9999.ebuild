# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=6

inherit eutils flag-o-matic toolchain-funcs multilib-minimal pax-utils git-r3

EGIT_REPO_URI="git://git.musl-libc.org/musl"
SRC_URI="
	http://dev.gentoo.org/~blueness/musl-misc/getconf.c
	http://dev.gentoo.org/~blueness/musl-misc/getent.c
	http://dev.gentoo.org/~blueness/musl-misc/iconv.c"

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
	eapply "${FILESDIR}"/kernel.patch
	eapply "${FILESDIR}"/musl-add-gnu-symbols.patch
	eapply "${FILESDIR}"/printf.patch
	eapply "${FILESDIR}"/glibc-abi-compat.patch
	eapply "${FILESDIR}"/qsort_r.patch
	eapply "${FILESDIR}"/ptrace.patch
	eapply "${FILESDIR}"/mallinfo.patch
	eapply "${FILESDIR}"/context.patch
	eapply "${FILESDIR}"/no-utf8-code-units-locale.patch
	eapply "${FILESDIR}"/multilib.patch
	eapply "${FILESDIR}"/backtrace.patch
	eapply "${FILESDIR}"/use-defines-instead-of-function.patch
	eapply "${FILESDIR}"/fix-configure.patch
	eapply_user
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

gen_ldscript() {
        local output_format
        output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
        [[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

        cat <<-END_LDSCRIPT
/* GNU ld script
   link only ld-arch.so
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

multilib_src_install() {

	MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bits/*
	)

	emake DESTDIR="${D}" install || die


	# musl provides ldd through its linker
	local ldso=$(basename "${D}"/$(get_libdir)/ld-musl-*)


	#move ld-musl and create linkerscript to directly link with libc.so
        mv -f "${D}"/usr/$(get_libdir)/libc.so "${D}"/$(get_libdir)/${ldso} || die

	gen_ldscript "/$(get_libdir)/${ldso}" > "${ED}/usr/$(get_libdir)/libc.so"

	dosym /$(get_libdir)/${ldso} /usr/bin/${CHOST}-ldd || die
	ar rcs ${D}/usr/$(get_libdir)/libintl.a || die

	# needed for ldd under pax kernel
	pax-mark r "${D}"/$(get_libdir)/${ldso} || die

}

multilib_src_install_all() {
	local ldso=$(basename "${D}"/$(get_libdir)/ld-musl-*)
	local i
        for i in getconf getent iconv; do
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/$i.c -o $i
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
