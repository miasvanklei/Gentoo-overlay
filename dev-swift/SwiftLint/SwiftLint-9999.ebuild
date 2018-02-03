# Copyright 1999-2017 Gentoo Foundation
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
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/corelibs-foundation
	dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-swift/Commandant
	dev-swift/Result
	dev-swift/Yams
	dev-swift/SourceKitten
	dev-swift/SwiftyTextTable"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
	${FILESDIR}/corelibs-foundation.patch
)

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lCommandant \
	-Xlinker -lResult \
	-Xlinker -lSourceKittenFramework \
	-Xlinker -lSwiftyTextTable \
	-Xlinker -lYams || die
}

src_install() {
        mkdir -p ${D}/usr/bin || die
        cp .build/release/swiftlint ${D}/usr/bin || die
}
