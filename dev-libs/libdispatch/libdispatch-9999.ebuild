# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 flag-o-matic

DESCRIPTION="The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dgrove-oss/swift-corelibs-libdispatch.git"
EGIT_BRANCH="internal-pwq-impl-remove-libpwq"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-libs/libbsd"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/fix-compile.patch
	eapply ${FILESDIR}/fix-segfault.patch
	eautoreconf
	eapply_user
}

src_configure() {
#	# fix use of nostdlib, link in libswiftCore
	find ./ -type f -exec sed -i -e 's|-nostdlib|-L/usr/lib/swift/linux -lswiftCore|g' {} \;
	econf --with-swift-toolchain=/usr --enable-embedded-blocks-runtime=off
}

src_compile() {
	# race conditions
	emake -j1
}

src_install() {
	default
	# not needed
	rm ${D}/usr/lib/swift/linux/libdispatch.la
}
