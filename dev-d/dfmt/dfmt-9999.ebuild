# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Dfmt is a formatter for D source code"
HOMEPAGE="https://github.com/Hackerpilot/dfmt"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Hackerpilot/dfmt.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

src_compile() {
	emake ldc
}

src_install() {
	dobin bin/dfmt
	dodoc README.md
}
