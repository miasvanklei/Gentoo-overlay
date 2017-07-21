# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=6

inherit eutils flag-o-matic toolchain-funcs pax-utils git-r3

EGIT_REPO_URI="git://git.musl-libc.org/musl"

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="+compat"

RDEPEND="!sys-apps/getent
	 compat? ( sys-libs/musl-compat )"

src_prepare() {
	eapply ${FILESDIR}/
	eapply_user
}

src_configure() {
	ECONF_SOURCE="${S}" \
        econf \
	--syslibdir=/lib \
	--libdir=/usr/lib \
	--disable-gcc-wrapper
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

src_install() {
	emake DESTDIR="${D}" install || die


	# musl provides ldd through its linker
	local arch=$("${D}"usr/lib/libc.so 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')

	# move ld-musl and create linkerscript to directly link with libc.so
        mv -f "${D}"/usr/lib/libc.so "${D}"/lib/ld-musl-${arch}.so.1 || die

	pushd "${D}" >/dev/null
	dosym /lib/ld-musl-${arch}.so.1 /usr/lib/libc.so
	popd >/dev/null

	#gen_ldscript "/lib/libc.so" > "${ED}/usr/lib/libc.so"


	# needed for ldd under pax kernel
	pax-mark r "${D}"/lib/ld-musl-${arch}.so.1 || die

	dosym /lib/ld-musl-${arch}.so.1 /usr/bin/${CHOST}-ldd || die
	dosym /lib/ld-musl-${arch}.so.1 /usr/bin/ldd || die

        cp "${FILESDIR}"/ldconfig.in "${T}" || die
        sed -e "s|@@ARCH@@|${arch}|" "${T}"/ldconfig.in > "${T}"/ldconfig || die
        into /
        dosbin "${T}"/ldconfig

	echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00musl || die
	doenvd "${T}"/00musl || die
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	# reload init ...
	/sbin/telinit U 2>/dev/null
}
