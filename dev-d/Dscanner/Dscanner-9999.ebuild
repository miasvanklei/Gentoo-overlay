# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Swiss-army knife for D source code"
HOMEPAGE="https://github.com/Hackerpilot/Dscanner"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Hackerpilot/Dscanner.git"

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_compile() {
	emake ldc || die
}

src_install() {
	dobin bin/dscanner
	dodoc README.md
}
