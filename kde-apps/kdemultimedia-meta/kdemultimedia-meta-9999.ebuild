# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="https://apps.kde.org/categories/multimedia/"

LICENSE="metapackage"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+audio +cdrom +ffmpeg gstreamer video"

RDEPEND="
	>=kde-apps/dragon-${PV}:${SLOT}
	audio? (
		>=media-sound/kasts-${PV}
	)
	cdrom? (
		>=kde-apps/audiocd-kio-${PV}:${SLOT}
		>=kde-apps/libkcddb-${PV}:${SLOT}
		>=kde-apps/libkcompactdisc-${PV}:${SLOT}
	)
	ffmpeg? ( >=kde-apps/ffmpegthumbs-${PV}:${SLOT} )
	video? ( >=kde-apps/kdenlive-${PV}:${SLOT} )
"

#	cdrom? (
#		>=kde-apps/k3b-${PV}:${SLOT}
#	)
#	audio? (
#		>=kde-apps/kwave-${PV}:${SLOT}
#		>=media-sound/krecorder-${PV}
#	)
#	gstreamer? ( >=kde-apps/kamoso-${PV}:${SLOT} )
