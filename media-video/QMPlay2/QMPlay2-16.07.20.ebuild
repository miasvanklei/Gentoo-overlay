# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils

DESCRIPTION="QMPlay2 is a video player, it plays all formats and stream"
HOMEPAGE="http://qt-apps.org/content/show.php/QMPlay2?content=153339"
SRC_URI="https://github.com/zaps166/${PN}/archive/${PV}.tar.gz -> QMplay2-${PV}.tar.gz"
LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~i686"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5"
RDEPEND="
	>=media-video/ffmpeg-1.2.0
	media-libs/libass
	media-libs/mesa
	x11-libs/libva
	x11-libs/libXv
	dev-libs/libcdio
	>=media-libs/taglib-1.9.1
	media-libs/libcddb
	media-sound/pulseaudio"

S=${WORKDIR}/${PN}-${PV}
