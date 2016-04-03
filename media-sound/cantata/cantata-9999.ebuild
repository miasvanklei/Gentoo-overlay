# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/llvm/llvm-9999.ebuild,v 1.90 2014/09/07 11:12:00 mgorny Exp $

EAPI=5

inherit cmake-utils git-r3

CMAKE_MAKEFILE_GENERATOR="ninja"
DESCRIPTION="Graphical MPD Client"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/CDrummond/cantata.git"
LICENSE="GPL-2"
SLOT="5"
KEYWORDS=""
IUSE="+cdda +cddb +dynamic +http-server lame +mtp +musicbrainz +qt5 +replaygain +taglib +udisks +stream remote +mpd vlc"
REQUIRED_USE="
        cddb? ( cdda taglib )
        cdda? ( udisks || ( cddb musicbrainz )  )
        lame? ( cdda taglib )
        mtp? ( taglib udisks )
        musicbrainz? ( cdda taglib )
        replaygain? ( taglib )
	vlc? ( vlc )
"
RDEPEND="
        sys-libs/zlib
        x11-libs/libX11
        cdda? ( media-sound/cdparanoia )
        cddb? ( media-libs/libcddb )
        lame? ( media-sound/lame )
        mtp? ( media-libs/libmtp )
        musicbrainz? ( media-libs/musicbrainz:5 )
        qt5? (
                dev-qt/qtconcurrent:5
                dev-qt/qtcore:5
                dev-qt/qtdbus:5
                dev-qt/qtgui:5
                dev-qt/qtnetwork:5
                dev-qt/qtsvg:5
                dev-qt/qtwidgets:5
                dev-qt/qtxml:5
        )
        !qt5? (
                dev-libs/qjson
                dev-qt/qtcore:4
                dev-qt/qtdbus:4
                dev-qt/qtgui:4
                dev-qt/qtsvg:4
)
        replaygain? (
                media-sound/mpg123
                virtual/ffmpeg
        )
        taglib? (
                media-libs/taglib[asf,mp4]
        )
	mpd? ( media-sound/mpd )
"
DEPEND="${RDEPEND}
        sys-devel/gettext
        qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${RDEPEND}
        dynamic? (
                dev-lang/perl[ithreads]
                dev-perl/URI
        )
"

# cantata has no tests
RESTRICT="test"

src_prepare() {
	epatch ${FILESDIR}/musl-includes.patch
	epatch ${FILESDIR}/qt-5.7.patch
}

src_configure() {
	local mycmakeargs=(
                $(cmake-utils_use_enable cdda CDPARANOIA)
                $(cmake-utils_use_enable cddb)
                $(cmake-utils_use_enable dynamic)
                $(cmake-utils_use_enable http-server HTTP_SERVER)
                $(cmake-utils_use_enable lame)
                $(cmake-utils_use_enable mtp)
                $(cmake-utils_use_enable musicbrainz)
                $(cmake-utils_use_enable qt5)
                $(cmake-utils_use_enable replaygain FFMPEG)
                $(cmake-utils_use_enable replaygain MPG123)
                $(cmake-utils_use_enable taglib)
                $(cmake-utils_use_enable udisks DEVICES_SUPPORT)
                $(cmake-utils_use_enable stream HTTP_STREAM_PLAYBACK)
		$(cmake-utils_use_enable remote REMOTE_DEVICES)
                $(cmake-utils_use_enable udisks)
                $(cmake-utils_use_enable vlc LIBVLC)
                -DUSE_SYSTEM_MENU_ICON=ON
        )
	cmake-utils_src_configure
}
