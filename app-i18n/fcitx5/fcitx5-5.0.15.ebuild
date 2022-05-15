# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2-utils xdg-utils

DESCRIPTION="Fcitx5 Next generation of fcitx "
HOMEPAGE="https://fcitx-im.org"
SRC_URI="https://download.fcitx-im.org/${PN}/${PN}/${P}_dict.tar.xz"

LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
KEYWORDS="~amd64"
SLOT="5"
IUSE="+enchant test coverage doc systemd wayland X"
REQUIRED_USE="coverage? ( test )"

RDEPEND="app-text/iso-codes
	app-i18n/unicode-cldr
	dev-libs/glib:2
	dev-libs/json-c
	dev-libs/libfmt
	dev-libs/libxml2
	sys-apps/dbus
	x11-libs/libxkbcommon[X?]
	x11-libs/libxkbfile
	x11-libs/cairo[X?]
	x11-libs/pango
	x11-misc/xkeyboard-config
	virtual/libiconv
	virtual/libintl
	enchant? ( app-text/enchant:2= )
	systemd? (
		dev-libs/libevent
		sys-apps/systemd
	)
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
	)
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrender
		x11-libs/xcb-imdkit
		x11-libs/xcb-util-keysyms
	)
"

BDEPEND="kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PRESAGE=FALSE
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_TEST=$(usex test)
		-DENABLE_COVERAGE=$(usex coverage)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DENABLE_DOC=$(usex doc)
		-DUSE_SYSTEMD=$(usex systemd)
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
