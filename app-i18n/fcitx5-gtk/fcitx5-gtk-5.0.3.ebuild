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
IUSE="gtk2 gtk3 introspection"

RDEPEND="app-i18n/fcitx5
	x11-libs/libxkbcommon
	x11-libs/libX11
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
"

BDEPEND="kde-frameworks/extra-cmake-modules
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
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3)
		-DENABLE_GTK4_IM_MODULE=OFF
		-DENABLE_SNOOPER=OFF
		-DENABLE_GIR=$(usex introspection)
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
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
