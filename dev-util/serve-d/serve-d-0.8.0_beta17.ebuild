# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Microsoft language server protocol implementation for D using workspace-d"
HOMEPAGE="https://github.com/Pure-D/serve-d"

MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4)).$(ver_cut 5)"
SRC_URI="https://github.com/Pure-D/serve-d/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

DEPEND="
	dev-util/d-tools
	dev-util/dub"
RDEPEND="${DEPEND}"

src_compile() {
	dub build --build=release --parallel || die
}

src_install() {
	dobin serve-d
}
