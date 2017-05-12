# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Swift OpenSSL and TLS wrapper"
HOMEPAGE="https://github.com/vapor/tls"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/tls.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Core
	dev-swift/Sockets"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	--verbose \
        -Xlinker -lCore \
        -Xlinker -lSockets || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
