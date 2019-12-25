# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ancillary tools for the D programming language compiler"
HOMEPAGE="https://github.com/dlang/tools"
SRC_URI="https://github.com/dlang/tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

BDEPEND="dev-util/dub"

DEPEND="dev-lang/ldc2"

RDEPEND="${DEPEND}"

S=${WORKDIR}/"${P//d}"

src_compile() {
	HOME=${S} dub build --build=release :ddemangle || die
	HOME=${S} dub build --build=release :rdmd || die
}

src_install() {
	newbin dtools_ddemangle ddemangle
	newbin dtools_rdmd rdmd
}

