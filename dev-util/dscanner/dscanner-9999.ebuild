# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The Dlang Completion Daemon is an auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
EGIT_REPO_URI="https://github.com/Hackerpilot/Dscanner"

inherit git-r3

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_compile() {
	make ldcbuild
}

src_install() {
	dobin bin/dscanner
	dodoc README.md
}
