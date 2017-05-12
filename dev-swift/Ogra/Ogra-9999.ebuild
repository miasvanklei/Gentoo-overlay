# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A companion project for the Argo library that facilitates converting back from model objects into JSON"
HOMEPAGE="https://github.com/edwardaux/Ogra.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/edwardaux/Ogra.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
        dev-swift/Argo"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
	${FILESDIR}/fix-compile.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lArgo \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
