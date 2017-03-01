# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Pure-Swift JSON parser & formatter. Fully streamable input and output. Linux & OS X ready. Replacement for NSJSONSerialization"
HOMEPAGE="https://github.com/DanToml/Jay"
SRC_URI=""
EGIT_REPO_URI="https://github.com/DanToml/Jay.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

src_prepare() {
        eapply ${FILESDIR}/install-lib.patch
	eapply_user
}

src_compile() {
	swift build -c release \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
