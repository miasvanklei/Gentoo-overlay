# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3

DESCRIPTION="Compatibility headers and utilities for musl libc systems"
HOMEPAGE="https://github.com/somasis/musl-compat"
SRC_URI="http://dev.gentoo.org/~blueness/musl-misc/iconv.c"
EGIT_REPO_URI="https://github.com/somasis/musl-compat.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc x86"
IUSE=""

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

src_prepare() {
	cp ${DISTDIR}/iconv.c ${S}/bin || die
	default
}

src_install() {
	emake install prefix=${D}/usr
	rm ${D}/usr/bin/ldconfig
	rm ${D}/usr/include/sys/queue.h
}
