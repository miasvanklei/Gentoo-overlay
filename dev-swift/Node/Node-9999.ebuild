# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A formatted data encapsulation meant to facilitate the transformation from one object to another"
HOMEPAGE="https://github.com/vapor/node"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/node.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Core
	dev-swift/Bits
	dev-swift/Debugging"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lCore \
	-Xlinker -lBits \
	-Xlinker -lDebugging \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
