# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="
	https://www.kde.org/applications/multimedia/
	https://multimedia.kde.org/
"
KEYWORDS=" ~amd64 ~x86"
IUSE="+ffmpeg"

# Add back whenever it is ported - no change since 4.10
# 	mplayer? ( $(add_kdeapps_dep mplayerthumbs) )
RDEPEND="
	$(add_kdeapps_dep kdenlive)
	ffmpeg? ( $(add_kdeapps_dep ffmpegthumbs) )
"
