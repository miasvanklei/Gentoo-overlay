# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A lightweight library for generating text tables."
HOMEPAGE="https://github.com/scottrhoyt/SwiftyTextTable"
SRC_URI=""
EGIT_REPO_URI="https://github.com/scottrhoyt/SwiftyTextTable.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/corefoundation.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib* ${D}/usr/lib/swift/linux || die
}
