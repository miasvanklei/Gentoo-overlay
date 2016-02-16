# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit  multilib-minimal

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""

src_unpack() {
	mkdir ${WORKDIR}/${PN}-${PV}
}

multilib_src_compile() {
	local libdir=$(get_libdir)

	${CC} -c ${FILESDIR}/${libdir#lib}/crtbegin.S -o crtbegin.o
	ln -s crtbegin.o crtbeginT.o
	${CC} -c ${FILESDIR}/${libdir#lib}/crtbegin.S -o crtbeginS.o -fPIC -DSHARED
	ln -s crtbeginS.o crtbeginP.o
	${CC} -c ${FILESDIR}/${libdir#lib}/crtend.S -o crtend.o
	${CC} -c ${FILESDIR}/${libdir#lib}/crtend.S -o crtendS.o -fPIC
}

multilib_src_install() {
	local gccversion=$(${CC} -dumpversion) || die
        mkdir -p ${D}/usr/lib/gcc/${CHOST}/${gccversion}
	cp crt* ${D}/usr/lib/gcc/${CHOST}/${gccversion}
}
