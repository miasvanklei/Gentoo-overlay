# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdemultimedia - merge this to pull in all kdemultimedia-derived packages"
HOMEPAGE="https://apps.kde.org/categories/multimedia/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+audio +cdrom +ffmpeg gstreamer video"

RDEPEND="
	>=kde-apps/dragon-${PV}:*
	audio? (
		>=media-sound/kasts-${PV}:*
		>=media-sound/krecorder-${PV}:*
	)
	cdrom? (
		>=kde-apps/audiocd-kio-${PV}:*
		>=kde-apps/libkcddb-${PV}:*
		>=kde-apps/libkcompactdisc-${PV}:*
	)
	ffmpeg? ( >=kde-apps/ffmpegthumbs-${PV}:* )
	video? ( >=kde-apps/kdenlive-${PV}:* )
"

#	cdrom? (
#		>=kde-apps/k3b-${PV}:*
#	)
#	audio? (
#		>=kde-apps/kwave-${PV}:*
#	)
#	gstreamer? ( >=kde-apps/kamoso-${PV}:* )
