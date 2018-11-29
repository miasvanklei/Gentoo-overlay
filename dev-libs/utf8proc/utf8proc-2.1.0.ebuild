# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="a clean C library for processing UTF-8 Unicode data"
HOMEPAGE="http://julialang.org/utf8proc"
SRC_URI="https://github.com/JuliaLang/${PN}/archive/v${PV//_/-}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT unicode"

SLOT="0/${PV}"

S="${WORKDIR}/${P/_/-}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="static-libs"

src_prepare() {
	eapply_user

	sed -r -e '/CFLAGS = / s, -(O2|pedantic),,g' \
		-i -- Makefile || die
}

src_install() {
	emake install \
		DESTDIR="${ED}" \
		prefix="${EPREFIX}"/usr \
		includedir="${EPREFIX}"/usr/include \
		libdir="${EPREFIX}/usr/$(get_libdir)"

	install -Dm644 ${FILESDIR}/libutf8proc.pc ${D}/usr/lib/pkgconfig/libutf8proc.pc || die
	einstalldocs
	dodoc NEWS.md

	use static-libs || rm "${ED}/usr/$(get_libdir)/lib${PN}.a"
}
