# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="HTTP, Generic, and Type-Safe Routing."
HOMEPAGE="https://github.com/vapor/routing"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/routing.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Core
	dev-swift/Engine
	dev-swift/Node"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/remove-dependencies.patch
	eapply ${FILESDIR}/install-lib.patch
	eapply_user
}

src_compile() {
	swift build -c release \
	-Xlinker -lNode \
	-Xlinker -lCore \
	-Xlinker -lHTTP \
	-Xlinker -lWebSockets \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
