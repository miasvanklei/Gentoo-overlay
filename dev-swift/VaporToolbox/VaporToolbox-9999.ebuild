# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Simplifies common command line tasks when using Vapor"
HOMEPAGE="https://github.com/vapor/toolbox"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/toolbox.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
        dev-swift/Console
        dev-swift/JSON"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lConsole \
	-Xlinker -lJSON \
	-Xlinker -lNode \
	-Xlinker -lCore \
	-Xlinker -lBits \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/bin || die
        cp .build/release/Executable ${D}/usr/bin/vapor || die
}
