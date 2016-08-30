# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2 autotools

DESCRIPTION="evolution-tray plugin"
HOMEPAGE="https://github.com/KostadinAtanasov/evolution-on"
SRC_URI=""

EGIT_REPO_URI="https://github.com/KostadinAtanasov/evolution-on.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_install() {
	emake DESTDIR=${D} install
}

pkg_postinst() {
        /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas
}
