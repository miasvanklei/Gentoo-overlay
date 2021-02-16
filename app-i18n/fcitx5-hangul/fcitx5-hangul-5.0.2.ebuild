# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://fcitx-im.org"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}.tar.xz"

LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
KEYWORDS="~amd64"
SLOT="5"
IUSE=""

RDEPEND="
	app-i18n/libhangul
	app-i18n/fcitx5
	virtual/libiconv
        virtual/libintl
"

BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_BUILD_TYPE=Release
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
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
