# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A tool to enforce Swift style and conventions"
HOMEPAGE="https://github.com/realm/SwiftLint"
SRC_URI=""
EGIT_REPO_URI="https://github.com/realm/SwiftLint.git"
EGIT_SUBMODULES=()

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Commandant
	dev-swift/Result
	dev-swift/Yams
	dev-swift/SwiftyTextTable
	dev-swift/SourceKitten"
DEPEND="${RDEPEND}"

src_prepare() {
        eapply ${FILESDIR}/remove-dependencies.patch
        eapply ${FILESDIR}/foundation.patch
        eapply_user
}

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lCommandant \
	-Xlinker -lSourceKittenFramework \
	-Xlinker -lSwiftyTextTable \
	-Xlinker -lYams \
	-Xlinker -lResult || die
}

src_install() {
        mkdir -p ${D}/usr/bin || die
        cp .build/release/swiftlint ${D}/usr/bin || die
}
