# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

#MY_P=${P/-standalone/}

DESCRIPTION="Compatibility headers and utilities for musl libc systems"
HOMEPAGE="https://github.com/somasis/musl-compat"
SRC_URI="https://github.com/somasis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://dev.gentoo.org/~blueness/musl-misc/iconv.c"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc x86"
IUSE=""

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	cp ${DISTDIR}/iconv.c ${S}/bin || die
	default
}

src_install() {
	emake install prefix=${D}/usr
	rm ${D}/usr/include/sys/cdefs.h
	rm ${D}/usr/bin/ldconfig
}
