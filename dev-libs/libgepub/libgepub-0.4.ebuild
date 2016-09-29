# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~arm-linux ~x86-linux"

COMMON_DEPEND="
	net-libs/webkit-gtk:4
	>=dev-libs/glib-2.46.0:2
	dev-libs/libxml2
	app-arch/libarchive
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}"
