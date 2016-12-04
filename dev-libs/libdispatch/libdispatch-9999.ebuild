# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3 flag-o-matic

DESCRIPTION="The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-libdispatch.git"
EGIT_BRANCH="swift-3.0-preview-1-branch"
EGIT_SUBMODULES=()

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-libs/compiler-rt
	dev-libs/libbsd
	dev-libs/libkqueue
	dev-libs/libpthread_workqueue"
DEPEND="${RDEPEND}"

src_prepare() {
	rmdir libpwq
	rmdir libkqueue
	eautoreconf
	eapply_user
}

src_configure() {
	# fix use of nostdlib
	append-ldflags -lkqueue
	find ./ -type f -exec sed -i -e 's/-nostdlib//g' {} \;
	econf --with-swift-toolchain=/usr --enable-embedded-blocks-runtime=off --disable-libkqueue-install --disable-libpwq-install
}

src_compile() {
	emake -j1
}
