# Copyright 2017 Mias van Klei
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Unicode tokeniser...."
HOMEPAGE="https://github.com/LanguageMachines/ucto"
SRC_URI="https://github.com/LanguageMachines/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0"

SLOT="0"

S="${WORKDIR}/${P/_/-}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
DEPEND="dev-libs/libxml2
	dev-libs/icu:=
	sci-libs/ticcutils
	sci-libs/libfolia
	sci-libs/uctodata
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
        econf --disable-static
}

src_install() {
        default
        find "${D}" -name '*.la' -delete || die
}
