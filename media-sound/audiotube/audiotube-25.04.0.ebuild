# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
ECM_TEST="forceoptional"

KFMIN=6.5.0
QTMIN=6.4.0
inherit ecm gear.kde.org

DESCRIPTION="Client for YouTube Music"
HOMEPAGE="https://apps.kde.org/audiotube/"

LICENSE="LGPL-3+"
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-db/futuresql-0.1.1
	dev-libs/kirigami-addons
	>=dev-libs/qcoro-0.10.0
	dev-python/pybind11
	dev-python/ytmusicapi
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[gstreamer]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	net-misc/yt-dlp
"

RDEPEND="${DEPEND}
"
