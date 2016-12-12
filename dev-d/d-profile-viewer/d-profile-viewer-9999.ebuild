# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

REVISION="b8292aad50da"

DESCRIPTION="Swiss-army knife for D source code"
HOMEPAGE="https://github.com/Hackerpilot/Dscanner"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI="https://bitbucket.org/andrewtrotman/d-profile-viewer/get/${REVISION}.zip -> d-profileviewer-${REVISION}.zip"

DEPEND="dev-lang/ldc2
	dev-util/dub"
RDEPEND="${DEPEND}"

S="${WORKDIR}/andrewtrotman-d-profile-viewer-${REVISION}"

src_compile() {
	dub build -b=release || die
}

src_install() {
	dobin d-profile-viewer
}
