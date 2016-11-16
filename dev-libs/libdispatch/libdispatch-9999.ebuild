# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-libdispatch.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libbsd"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/fix-includes.patch
	eautoreconf
	eapply_user
}

src_configure() {
	#fix use of nostdlib
	find ./ -type f -exec sed -i -e 's/-nostdlib//g' {} \;
	econf --with-swift-toolchain=/usr
}

src_compile() {
	emake -j1
}
