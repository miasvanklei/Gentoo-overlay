# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
ECM_TEST="forceoptional"

KFMIN=6.19.0
QTMIN=6.10.0
inherit ecm gear.kde.org xdg

DESCRIPTION="Client for YouTube Music"
HOMEPAGE="https://apps.kde.org/audiotube/"
SRC_URI="https://invent.kde.org/graphics/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="LGPL-3+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"

RDEPEND="${DEPEND}
"

S="${WORKDIR}/${PN}-v${PV}"

PATCHES=(
	"${FILESDIR}/fix-show-virtual-keyboard-on-text-edit.patch"
)

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
