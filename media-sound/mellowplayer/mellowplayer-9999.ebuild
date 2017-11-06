# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit cmake-utils git-r3

EGIT_REPO_URI="https://github.com/ColinDuquesnoy/MellowPlayer"
DESCRIPTION="Cloud music integration for your desktop"
HOMEPAGE="https://github.com/ColinDuquesnoy/MellowPlayer"
KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
LICENSE="GPL-2.0"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtwebengine
	x11-libs/libX11
	x11-libs/libXext
	virtual/pkgconfig"
DEPEND=">=dev-util/cmake-2.8
	${RDEPEND}"
