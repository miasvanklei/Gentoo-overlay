# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_5 )
PYTHON_REQ_USE='threads(+)'

DESCRIPTION="The third generation of Nuvola Player - cloud music integration for your Linux desktop"
HOMEPAGE="https://tiliado.eu/nuvolaplayer"
SRC_URI="https://github.com/tiliado/nuvolaplayer/archive/3.0.3.tar.gz -> nuvolaplayer-3.0.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

inherit python-single-r1 waf-utils gnome2-utils vala flag-o-matic

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/libgee
	dev-libs/json-glib
	net-libs/webkit-gtk:4[gstreamer]
	media-libs/gstreamer:1.0
	media-gfx/scour
	>=net-libs/libsoup-2.34
	x11-libs/gdk-pixbuf[jpeg]
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch ${FILESDIR}/fix-stupid-options.patch
	vala_src_prepare
}

src_configure() {
	append-cflags "-Wno-return-type"
	waf-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
