# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.248
inherit ecm kde.org

DESCRIPTION="GStreamer backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/phonon-backend-gstreamer/${PV}/phonon-backend-gstreamer-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="alsa debug +network"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-qt/qtbase:6
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	>=media-libs/phonon-4.11.0[qt6(+)]
	media-plugins/gst-plugins-meta:1.0[alsa?,ogg,vorbis]
	virtual/opengl
"
RDEPEND="${DEPEND}
	network? ( media-plugins/gst-plugins-soup:1.0 )
"

PATCHES=(
	"${FILESDIR}"/qt6.patch
)
