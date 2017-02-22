# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3 flag-o-matic

DESCRIPTION="The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-libdispatch.git"
EGIT_SUBMODULES=()

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-libs/libbsd
	dev-libs/libpthread_workqueue"
DEPEND="${RDEPEND}"

src_prepare() {
	rmdir libpwq
	eapply ${FILESDIR}/fix-compile.patch
	eapply ${FILESDIR}/fix-segfault.patch
	eautoreconf
	eapply_user
}

src_configure() {
	# fix use of nostdlib
	append-ldflags -L/usr/lib/swift/linux -lswiftCore
	find ./ -type f -exec sed -i -e 's/-nostdlib//g' {} \;
	econf --with-swift-toolchain=/usr --enable-embedded-blocks-runtime=off --disable-libpwq-install
}

src_compile() {
	# race conditions
	emake -j1
}

src_install() {
	default
	rm ${D}/usr/lib/swift/linux/libdispatch.la
}
