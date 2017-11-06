# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Infix operators for monadic functions in Swift https://thoughtbot.com/open-source"
HOMEPAGE="https://github.com/thoughtbot/Runes.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/thoughtbot/Runes.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

PATCHES=(
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	touch Tests/LinuxMain.swift
	swift build -c release \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
