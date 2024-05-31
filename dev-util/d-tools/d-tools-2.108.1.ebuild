# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Ancillary tools for the D programming language compiler"
HOMEPAGE="https://github.com/dlang/tools"
LICENSE="BSL-1.1"
SRC_URI="https://github.com/dlang/tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

BDEPEND="dev-util/dub"

S="${WORKDIR}/tools-${PV}"

src_compile() {
        dub build --build=release --parallel :ddemangle || die
        dub build --build=release --parallel :rdmd || die
}

src_install() {
        newbin dtools_ddemangle ddemangle
        newbin dtools_rdmd rdmd
}

