# Copyright 2017 Mias van Klei
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Ticcutils, a generic utility library shared by our software"
HOMEPAGE="https://github.com/LanguageMachines/ticcutils"
SRC_URI="https://github.com/LanguageMachines/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0"

SLOT="0"

S="${WORKDIR}/${P/_/-}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="bzip2 tar zlib"
DEPEND="dev-libs/libxml2
	dev-libs/icu
	virtual/pkgconfig
	bzip2? ( app-arch/bzip2 )
	tar? ( dev-libs/libtar )
	zlib? ( sys-libs/zlib )"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
	--disable-static \
	--with-boost=no \
	--with-boost-regex=no
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
