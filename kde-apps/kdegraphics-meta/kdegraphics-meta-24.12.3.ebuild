# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegraphics - merge this to pull in all kdegraphics-derived packages"
HOMEPAGE="https://kde.org/applications/graphics/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="color-management scanner screencast"

RDEPEND="
	>=kde-apps/okular-${PV}:*
	>=kde-apps/spectacle-${PV}:*
	>=kde-apps/svgpart-${PV}:*
	>=kde-apps/thumbnailers-${PV}:*
	>=kde-apps/gwenview-${PV}:*
	>=kde-apps/kolourpaint-${PV}:*
	color-management? ( >=kde-misc/colord-kde-${PV}:* )
	screencast? ( >=kde-apps/spectacle-${PV}:* )
"
#        scanner? (
#                >=kde-apps/libksane-${PV}:${SLOT}
#                >=kde-misc/skanlite-${PV}:${SLOT}
#                >=media-gfx/skanpage-${PV}:${SLOT}
#        )
