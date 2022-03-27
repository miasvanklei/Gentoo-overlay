# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Microsoft language server protocol implementation for D using workspace-d"
HOMEPAGE="https://github.com/Pure-D/serve-d"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""
MY_PV="${PV/_rc1/-rc.1}"
RESTRICT="network-sandbox"

SRC_URI="https://github.com/Pure-D/serve-d/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

DEPEND="
	dev-util/d-tools
	dev-util/dub"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	dub build --build=release --parallel || die
}

src_install() {
	dobin serve-d
}
