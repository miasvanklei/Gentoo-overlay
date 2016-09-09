# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Automatic archives creating and extracting library"
HOMEPAGE=""

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
IUSE="introspection"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.45.7:2
	>=x11-libs/gtk+-3.19.12:3[introspection?]
	app-arch/libarchive
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.10
"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install
}
