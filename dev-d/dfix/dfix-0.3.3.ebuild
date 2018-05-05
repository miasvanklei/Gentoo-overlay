# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dfmt is a formatter for D source code"
HOMEPAGE="https://github.com/dlang-community/dfmt"
SRC_URI="https://github.com/dlang-community/dfix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="net-misc/curl
	dev-lang/ldc2
	dev-util/dub"
RDEPEND="${DEPEND}"

src_compile() {
	HOME=${S} dub build --build=release || die
}

src_install() {
	dobin dfix
	dodoc README.md
}
