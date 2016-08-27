# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The Dlang Completion Daemon is an auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI="https://github.com/Hackerpilot/Dscanner/archive/v0.4.0-alpha.8.tar.gz"

DEPEND="dev-lang/ldc2
	dev-util/dub"
RDEPEND="${DEPEND}"

S=${WORKDIR}/Dscanner-0.4.0-alpha.8

src_compile() {
	dub build
}

src_install() {
	dobin dscanner
	dodoc README.md
}
