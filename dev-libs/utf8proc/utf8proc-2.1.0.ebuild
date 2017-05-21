# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="a clean C library for processing UTF-8 Unicode data"
HOMEPAGE="https://julialang.org/utf8proc/releases"
SRC_URI="https://github.com/JuliaLang/${PN}/archive/v${PV//_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE=""

RDEPEND=""
DEPEND="
	!dev-libs/libutf8proc
${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_install() {
	emake install prefix=/usr DESTDIR=${D}
	install -Dm644 ${FILESDIR}/libutf8proc.pc ${D}/usr/lib/pkgconfig/libutf8proc.pc || die
}
