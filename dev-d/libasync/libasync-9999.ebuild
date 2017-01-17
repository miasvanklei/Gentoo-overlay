# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Cross-platform event loop library of asynchronous objects"
HOMEPAGE="https://github.com/etcimon/libasync"
SRC_URI=""
EGIT_REPO_URI="https://github.com/etcimon/libasync.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-util/dub"
RDEPEND="${DEPEND}"

src_compile() {
	dub build -b=release
}

src_install() {
	dolib build/libasync.a
	insinto /usr/include/libasync
	doins -r source/*
}
