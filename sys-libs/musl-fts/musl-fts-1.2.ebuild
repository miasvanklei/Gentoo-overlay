# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="A standalone library to implement fts."
HOMEPAGE="https://github.com/pullmoll/musl-fts"
SRC_URI="https://github.com/pullmoll/musl-fts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="!sys-libs/glibc
	!sys-libs/uclibc"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
        ECONF_SOURCE="${S}" \
        econf \
        $(use_enable static-libs static)
}

multilib_src_install() {
        default
        insinto /usr/lib/pkgconfig
        doins musl-fts.pc
}

