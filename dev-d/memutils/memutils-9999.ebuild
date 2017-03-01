# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Overhead allocators, allocator-aware containers and lifetime management for D objects"
HOMEPAGE="https://github.com/etcimon/memutils"
SRC_URI=""
EGIT_REPO_URI="https://github.com/etcimon/memutils.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-util/dub"
RDEPEND="${DEPEND}"

src_prepare()
{
	eapply ${FILESDIR}/shared.patch
	eapply_user
}

src_compile() {
	dub build -b=release || die
}

src_install() {
	dolib libmemutils.so
	insinto /usr/include/d
	doins -r source/*
}
