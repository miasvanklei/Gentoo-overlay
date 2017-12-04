# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PLOCALES="de ja zh_CN zh_TW"

inherit cmake-utils eutils l10n

DESCRIPTION="Japanese libkkc module for Fcitx"
HOMEPAGE="https://github.com/fcitx/fcitx-kkc"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcitx/${PN}.git"
	EGIT_BRANCH="master"
else
	SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt5"

COMMON_DEPEND=">=app-i18n/fcitx-4.2.8
	>=app-i18n/libkkc-0.2.3
	qt5? (
		app-i18n/fcitx-qt5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5 )"
DEPEND="${COMMON_DEPEND}
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	sys-devel/gettext
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	app-i18n/libkkc-data
	app-i18n/skk-jisyo"

RESTRICT="mirror"

src_prepare() {
	disable_locale() {
		sed -i "s/ ${1}//" po/CMakeLists.txt
	}

	l10n_for_each_disabled_locale_do disable_locale
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable qt5 QT)
	)
	cmake-utils_src_configure
}
