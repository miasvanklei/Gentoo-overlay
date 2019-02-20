# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Format conversion utility that can be used with xfig"
HOMEPAGE="http://www.xfig.org/"
SRC_URI="mirror://sourceforge/mcj/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXpm
	media-libs/libpng
	sys-devel/bc"
DEPEND="${RDEPEND}"

src_configure() {
	econf --enable-transfig
}

src_compile() {
	emake FIG2DEV_LIBDIR=/usr/share/fig2dev XFIGLIBDIR=/usr/share/xfig
}

src_install() {
	emake DESTDIR="${D}"\
	FIG2DEV_LIBDIR=/usr/share/fig2dev XFIGLIBDIR=/usr/share/xfig MANPATH=/usr/share/man install
}
