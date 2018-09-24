# Copyright 2017 Mias van Klei
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="MBT: Memory-based tagger generation and tagging MBT is a memory-based tagger-generator and tagger in one."
HOMEPAGE="https://github.com/LanguageMachines/mbt"
SRC_URI="https://github.com/LanguageMachines/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0"

SLOT="0"

S="${WORKDIR}/${P/_/-}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
DEPEND="sci-libs/ticcutils
	sci-libs/timbl
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
