# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
HOMEPAGE="https://github.com/gnunn1/tilix"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
SRC_URI="https://github.com/gnunn1/tilix/archive/${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-lang/ldc2
	dev-util/dub
	x11-libs/GtkD"
RDEPEND="${DEPEND}"

src_prepare()
{
	eapply_user
	eautoreconf
}

pkg_preinst(){
	gnome2_schemas_savelist
}

pkg_postinst(){
        gnome2_gconf_install
        gnome2_schemas_update
}

pkg_postrm(){
	gnome2_gconf_uninstall
        gnome2_schemas_update
}
