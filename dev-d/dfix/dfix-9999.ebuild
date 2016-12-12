# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Tool for automatically upgrading D source code"
HOMEPAGE="https://github.com/Hackerpilot/dfix.git"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Hackerpilot/dfix.git"

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply ${FILESDIR}/fix-makefile.patch
	default
}

src_compile() {
	DMD=ldc2 emake || die
}

src_install() {
	dobin bin/dfix
	dodoc README.md
}
