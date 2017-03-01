# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A web framework and server for Swift that works on macOS and Ubuntu. https://vapor.codes"
HOMEPAGE="https://github.com/vapor/vapor.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/vapor.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Crypto
	dev-swift/Fluent
	dev-swift/Engine
	dev-swift/Console
	dev-swift/JSON
	dev-swift/Turnstile
	dev-swift/Leaf
	dev-swift/Routing"
DEPEND="${RDEPEND}"

src_prepare() {
        eapply ${FILESDIR}/dependencies-add-libs.patch
        eapply ${FILESDIR}/fix-compile.patch
	eapply_user
}

src_compile() {
	swift build -c release \
	-Xlinker -lFluent \
	-Xlinker -lConsole \
	-Xlinker -lJSON \
	-Xlinker -lTurnstile \
	-Xlinker -lLeaf \
	-Xlinker -lRouting \
	-Xlinker -lTypeSafeRouting \
	-Xlinker -lHMAC \
	-Xlinker -lCipher \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
