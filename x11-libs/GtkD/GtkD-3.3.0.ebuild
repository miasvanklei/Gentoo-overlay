# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
HOMEPAGE="https://github.com/gnunn1/terminix"
LICENSE="MIT"

SLOT="3"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

SRC_URI="http://gtkd.org/Downloads/sources/${P}.zip"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/gtksourceview-3.20:3.0
	>=media-libs/gstreamer-1.8:1.0
	>=x11-libs/vte-0.43:2.91"

S=${WORKDIR}

src_compile() {
	unset LDFLAGS
	make all
}

src_install() {
	make DESTDIR=${D} prefix=/usr install-headers-gtkd install-headers-gtkdsv install-headers-gstreamer install-headers-vte || die
	make DESTDIR=${D} prefix=/usr install install-gstreamer install-vte \
		install-shared install-shared-gstreamer install-shared-vte || die
}
