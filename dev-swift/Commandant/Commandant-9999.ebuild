# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Type-safe command line argument handling"
HOMEPAGE="https://github.com/Carthage/Commandant.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Carthage/Commandant.git"
EGIT_SUBMODULES=()

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Result"
DEPEND="${RDEPEND}"

PATCHES=(
        ${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lResult || die
}

src_install() {
	mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
	cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
	cp .build/release/lib* ${D}/usr/lib/swift/linux || die
}
