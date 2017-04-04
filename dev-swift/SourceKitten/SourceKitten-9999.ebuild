# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS=""
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

src_prepare() {
        eapply ${FILESDIR}/fix-crash.patch
        eapply ${FILESDIR}/fix-run.patch
        eapply ${FILESDIR}/remove-dependencies.patch
        eapply ${FILESDIR}/install-lib.patch
#        eapply ${FILESDIR}/corefoundation.patch
	rm ${S}/Source/SourceKittenFramework/clang-c/module.modulemap
        eapply_user
}

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lCommandant \
	-Xlinker -lSWXMLHash \
	-Xlinker -lYams || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        mkdir -p ${D}/usr/bin || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib* ${D}/usr/lib/swift/linux || die
        cp .build/release/sourcekitten ${D}/usr/bin || die
}
