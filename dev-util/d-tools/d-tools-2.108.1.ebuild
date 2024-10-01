# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Ancillary tools for the D programming language compiler"
HOMEPAGE="https://github.com/dlang/tools"
SRC_URI="https://github.com/dlang/tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/tools-${PV}"

LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-util/dub"

src_compile() {
	dub build --build=release --parallel :ddemangle || die
	dub build --build=release --parallel :rdmd || die
}

src_install() {
	newbin dtools_ddemangle ddemangle
	newbin dtools_rdmd rdmd
}
