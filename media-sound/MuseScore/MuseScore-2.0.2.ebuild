# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musescore/musescore-1.3.ebuild,v 1.2 2014/04/16 06:11:17 polynomial-c Exp $

EAPI=5
inherit cmake-utils eutils font

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://mscore.sourceforge.net"
SRC_URI="http://ftp.osuosl.org/pub/musescore/releases/${PN}-2.0.2/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsndfile-1.0.19
	sys-libs/zlib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qthelp:5"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/pch.patch
	grep -rl --include=\*.txt -- "-g"  ./ | xargs sed -i 's/ -g / /g'
	grep -rl --include=\*.txt -- "-g"  ./ | xargs sed -i 's/ -g/ /g'
	grep -rl --include=\*.txt -- "-g"  ./ | xargs sed -i 's/-g / /g'
	sed -i 's/math.h/cmath/g' mstyle/colorutils.cpp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_JACK=OFF
	)

	cmake-utils_src_configure

	find ../ -name link.txt | xargs sed -i 's/-fPIE/-fPIC/g'
	find ../ -name flags.make | xargs sed -i 's/-fPIE/-fPIC/g'
}

src_compile() {
	cmake-utils_src_make lrelease
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
}
