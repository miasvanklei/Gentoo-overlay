# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A Swift implementation of the open Language Server Protocol"
HOMEPAGE="https://github.com/RLovelett/langserver-swift"
SRC_URI=""
EGIT_REPO_URI="https://github.com/RLovelett/langserver-swift.git"
EGIT_SUBMODULES=()

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/SourceKitten
	dev-swift/Argo
	dev-swift/Curry
	dev-swift/Regex"
DEPEND="${RDEPEND}"

src_prepare() {
        eapply ${FILESDIR}/remove-dependencies.patch
        eapply ${FILESDIR}/fix-compile.patch
        eapply_user
}

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lSourceKittenFramework \
	-Xlinker -lArgo \
	-Xlinker -lCurry \
	-Xlinker -lRegex || die
}

src_install() {
	dobin .build/release/LanguageServer
}
