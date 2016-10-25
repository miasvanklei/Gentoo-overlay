# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="tool for providing auto completion data for Nim source code"
HOMEPAGE="https://github.com/nim-lang/nimsuggest"
EGIT_REPO_URI="https://github.com/nim-lang/nimsuggest"
EGIT_CLONE_TYPE="shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/nim-0.15.0
	dev-nim/nimble"
RDEPEND=""

src_compile() {
	nimble build || die "compile failed"
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}
}
