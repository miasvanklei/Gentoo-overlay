# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Wraps dcd, dfmt and dscanner to one unified environment managed by dub"
HOMEPAGE="https://github.com/Pure-D/workspace-d"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Pure-D/workspace-d.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-util/dub"
RDEPEND="${DEPEND}"

src_compile() {
	dub --build=release || die
}

src_install() {
	dobin workspace-d
	dodoc README.md
}
