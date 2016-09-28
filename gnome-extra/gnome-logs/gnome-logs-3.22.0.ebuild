# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Logs is a viewer for the systemd journal."
HOMEPAGE="https://git.gnome.org/browse/gnome-logs"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~arm-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.46.0:2
	sys-apps/systemd
	>=x11-libs/gtk+-3.21.5:3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"
