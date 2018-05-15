# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Swiss-army knife for D source code"
HOMEPAGE="https://github.com/Hackerpilot/Dscanner"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI="https://github.com/dlang-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-lang/ldc2
	dev-util/dub"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-build.patch
)

src_compile() {
	HOME=${S} dub build --build=release || die
}

src_install() {
	dobin bin/dscanner
	dodoc README.md
}
