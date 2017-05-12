# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A Swift implementation of the open Language Server Protocol"
HOMEPAGE="https://github.com/RLovelett/langserver-swift"
SRC_URI=""
EGIT_REPO_URI="https://github.com/RLovelett/langserver-swift.git"
EGIT_COMMIT="c064e240b1476d37f59a3af51b812a3a5df1ebb6"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/SourceKit
	dev-swift/Argo
	dev-swift/Ogra
	dev-swift/Curry"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/remove-macness.patch
)

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lSourceKittenFramework \
	-Xlinker -lArgo \
	-Xlinker -lOgra \
	-Xlinker -lCurry || die
}

src_install() {
	dobin .build/release/LanguageServer
}
