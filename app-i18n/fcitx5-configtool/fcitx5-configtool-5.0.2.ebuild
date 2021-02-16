# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}.tar.xz"
KEYWORDS="~amd64"

LICENSE="GPL-2+"
SLOT="5"
IUSE="+kcm +config-qt test"

RDEPEND="app-i18n/fcitx5
	app-i18n/fcitx5-qt
	app-text/iso-codes
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kitemviews:5
	kde-frameworks/kwidgetsaddons:5
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile
	kcm? (
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
	        kde-frameworks/kirigami:5
	        kde-frameworks/kdeclarative:5
	)
	!kcm? ( dev-qt/qtdeclarative )
	config-qt? ( kde-frameworks/kitemviews:5 )
"

BDEPEND="kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_USE_QT_SYS_PATHS=yes
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_CONFIG_QT=$(usex config-qt)
	        -DENABLE_TEST=$(usex test)
	)

	cmake_src_configure
}
