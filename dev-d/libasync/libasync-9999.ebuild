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

DEPEND="dev-util/dub
	dev-d/memutils"
RDEPEND="${DEPEND}"

src_prepare()
{
	eapply ${FILESDIR}/shared.patch
	eapply ${FILESDIR}/musl.patch
	eapply_user
}

src_compile() {
	dub build -b=release || die
}

src_install() {
	dolib build/libasync.so
	insinto /usr/include/d
	doins -r source/*
}
