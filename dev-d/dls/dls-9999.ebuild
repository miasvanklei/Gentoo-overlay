# Copyright 2017 Mias van Klei
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Microsoft language server protocol implementation for D using workspace-d"
HOMEPAGE="https://github.com/Pure-D/serve-d"
EGIT_REPO_URI="https://github.com/d-language-server/dls.git"
SRC_URI=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

DEPEND="dev-util/dub"
RDEPEND="${DEPEND}"

src_compile() {
	HOME=${S} dub build --build=release || die
}

src_install() {
	dobin dls
}
