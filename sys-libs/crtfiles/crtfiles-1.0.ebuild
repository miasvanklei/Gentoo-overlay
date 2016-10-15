# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=6

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""

src_unpack() {
	mkdir ${WORKDIR}/${PN}-${PV}
}

src_compile() {
	${CC} -c ${FILESDIR}/crtbegin.S -o crtbegin.o
	ln -s crtbegin.o crtbeginT.o
	${CC} -c ${FILESDIR}/crtbegin.S -o crtbeginS.o -fPIC -DSHARED
	ln -s crtbeginS.o crtbeginP.o
	${CC} -c ${FILESDIR}/crtend.S -o crtend.o
	${CC} -c ${FILESDIR}/crtend.S -o crtendS.o -fPIC
}

src_install() {
        mkdir -p ${D}/usr/lib/
	cp crt* ${D}/usr/lib/
}
