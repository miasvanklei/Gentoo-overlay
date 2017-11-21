# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="An adorable little framework and command line tool for interacting with SourceKit."
HOMEPAGE="https://github.com/jpsim/SourceKitten"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jpsim/SourceKitten.git"
EGIT_SUBMODULES=()

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Commandant
	dev-swift/SWXMLHash
	dev-swift/Yams
	dev-swift/SourceKit"
DEPEND="${RDEPEND}"


PATCHES=(
	${FILESDIR}/remove-dependencies.patch
	${FILESDIR}/install-lib.patch
        ${FILESDIR}/fix-crash.patch
        ${FILESDIR}/fix-run.patch
)

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lCommandant \
	-Xlinker -lSWXMLHash \
	-Xlinker -lYams || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
        mkdir -p ${D}/usr/bin || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/lib* ${D}/usr/lib/swift/linux || die
        cp .build/release/sourcekitten ${D}/usr/bin || die
}
