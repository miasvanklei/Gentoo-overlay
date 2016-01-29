# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils user

DESCRIPTION="QMPlay2 is a video player, it plays all formats and stream"
HOMEPAGE="http://qt-apps.org/content/show.php/QMPlay2?content=153339"
SRC_URI="https://github.com/zaps166/${PN}/archive/${PV}.tar.gz"
LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~i686"
IUSE="-pulseaudio openal youtube"

DEPEND="dev-qt/qtcore:5"
RDEPEND="
	>=media-video/ffmpeg-1.2.0
	media-libs/libass
	media-libs/mesa
	x11-libs/libva
	x11-libs/libXv
	dev-libs/libcdio
	>=media-libs/taglib-1.9.1
	media-libs/libcddb
	youtube? ( net-misc/youtube-dl )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )
    "

S=${WORKDIR}/${PN}-${PV}

RESTRICT="strip"

src_configure(){
    cd "${S}"

     if use openal ; then # activate  libavresample of ffmpeg (openal)
        sed "26s|# DEFINES|DEFINES|" -i src/qmplay2/qmplay2.pro || die "sed failed"
        sed "27s|# LIBS|LIBS|" -i src/qmplay2/qmplay2.pro || die "sed failed"
	    sed "28s|# LIBS|LIBS|" -i src/qmplay2/qmplay2.pro || die "sed failed"
      fi

    if ! use pulseaudio ; then
	    cd "${S}"
        sed -i "5s|XVideo PulseAudio|XVideo|g" "${S}"/src/modules/modules.pro || die "sed failed"
    fi
    NOTERM=1 SYSTEM_BUILD=1 ./compile_unix 0
}

src_install() {
	cd ${S}
	dodir /usr
	cp -pPR "${S}"/app/* "${D}"/usr/ || die "copying files failed!"
}

