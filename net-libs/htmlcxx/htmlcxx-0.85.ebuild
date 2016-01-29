# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="a simple non-validating css1 and html parser for C++"
HOMEPAGE="http://sf.net/projects/${PN}"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ptrdiff_t.patch
}
