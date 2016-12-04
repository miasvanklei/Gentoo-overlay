# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="Portable implementation of the kqueue() and kevent() system calls"
HOMEPAGE="https://github.com/mheily/${PN}"
EGIT_REPO_URI="https://github.com/mheily/${PN}.git"
KEYWORDS=""

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	rm ${D}/usr/lib/libkqueue.la
	mv ${D}/usr/include/kqueue/* ${D}/usr/include
	rmdir ${D}/usr/include/kqueue
}
