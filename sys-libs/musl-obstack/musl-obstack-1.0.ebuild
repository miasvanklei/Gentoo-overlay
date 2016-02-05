# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="A standalone library to implement GNU libc's obstack."
HOMEPAGE="https://github.com/pullmoll/musl-obstack"
SRC_URI="https://github.com/pullmoll/musl-obstack/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="!sys-libs/glibc
	!sys-libs/uclibc"

src_prepare() {
	default
	epatch "${FILESDIR}"/obstack-printf.patch
	eautoreconf
}

src_configure() {
	econf \
	$(use_enable static-libs static)
}

src_install() {
	default
	insinto /usr/lib/pkgconfig
	doins musl-obstack.pc
}
