# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="https://kde.org/applications/graphics/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="scanner"

RDEPEND="
	>=kde-apps/svgpart-${PV}:${SLOT}
	>=kde-apps/gwenview-${PV}:${SLOT}
	>=kde-apps/kolourpaint-${PV}:${SLOT}
	>=kde-apps/okular-${PV}:${SLOT}
	>=kde-apps/spectacle-${PV}:${SLOT}
	>=kde-apps/thumbnailers-${PV}:${SLOT}
	scanner? ( >=kde-apps/libksane-${PV}:${SLOT} )
"
