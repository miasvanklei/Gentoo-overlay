# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="An implementation of xim protocol in xcb"
HOMEPAGE="https://gitlab.com/fcitx/xcb-imdkit"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}.tar.xz"

LICENSE="BSD-1 GPL-2+ LGPL-2+ MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=""

RDEPEND="dev-libs/uthash
	x11-libs/xcb-util
	x11-libs/xcb-util-keysyms"
DEPEND="${RDEPEND}
	virtual/pkgconfig"


src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake_src_configure
}

src_install(){
	cmake_src_install
}
