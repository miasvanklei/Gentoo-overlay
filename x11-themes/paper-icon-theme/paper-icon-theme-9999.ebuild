# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Numix icon theme"
HOMEPAGE="https://numixproject.org"

inherit git-r3 autotools
SRC_URI=""
EGIT_REPO_URI="https://github.com/snwh/${PN}.git"
KEYWORDS=""

LICENSE="GPL-3.0+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}
