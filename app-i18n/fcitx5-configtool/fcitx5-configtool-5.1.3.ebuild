# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Configuration module for Fcitx"
HOMEPAGE="https://fcitx-im.org"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

SLOT="5"
IUSE="+kcm +config-qt qt5 qt6 test"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="app-i18n/fcitx:5
	app-i18n/fcitx-qt:5
	app-text/iso-codes
	virtual/libintl
	x11-libs/libX11
	x11-libs/libxkbfile
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		kde-frameworks/kwidgetsaddons:5
	)
	qt6? (
		dev-qt/qtbase:6
		kde-frameworks/kwidgetsaddons:6
	)
	kcm? (
		qt5? (
			kde-frameworks/kconfigwidgets:5
			kde-frameworks/kcoreaddons:5
			kde-frameworks/ki18n:5
			kde-frameworks/kirigami:5
			kde-frameworks/kdeclarative:5
			kde-plasma/libplasma:5
		)
		qt6? (
			kde-frameworks/kconfigwidgets:6
			kde-frameworks/kcoreaddons:6
			kde-frameworks/ki18n:6
			kde-frameworks/kirigami:6
			kde-frameworks/kdeclarative:6
			kde-plasma/libplasma:6
		)
	)
	config-qt? (
		qt5? ( kde-frameworks/kitemviews:5 )
		qt6? ( kde-frameworks/kitemviews:6 )
	)
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
		-DUSE_QT6=$(usex qt6 On Off)
	)

	cmake_src_configure
}
