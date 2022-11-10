# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The agent for Coder Cloud"
HOMEPAGE="https://github.com/cdr/cloud-agent"
SRC_URI="https://github.com/cdr/cloud-agent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

BDEPEND=(
	dev-lang/go
)

src_unpack() {
	default
}

src_compile() {
	go build -o coder-cloud-agent  main.go || die
}

src_install() {
	dobin coder-cloud-agent
}
