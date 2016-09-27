# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
HOMEPAGE="https://github.com/gnunn1/terminix"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="debug"

SRC_URI="https://github.com/gnunn1/${PN}/archive/${PV}.tar.gz"

DEPEND="x11-libs/GtkD
	dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

