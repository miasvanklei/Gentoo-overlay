# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://fcitx-im.org"
EGIT_REPO_URI="https://github.com/fcitx/fcitx5-qt.git"

LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
KEYWORDS="~amd64"
SLOT="5"
IUSE="qt5 qt6 X"

RDEPEND="app-i18n/fcitx5
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5 )
	qt6? (
		dev-qt/qtbase:6
	)
"

BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_QT4=Off
		-DENABLE_QT5=$(usex qt5 On Off)
		-DENABLE_QT6=$(usex qt6 On Off)
		-DENABLE_X11=$(usex X On Off)
	)

	cmake_src_configure
}

src_install(){
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	elog
	elog "Follow the instrcutions of https://wiki.gentoo.org/wiki/Fcitx#Using_Fcitx"
	elog "and change the fcitx to fcitx5"
	elog
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
