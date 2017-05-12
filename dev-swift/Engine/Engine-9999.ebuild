# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="HTTP, WebSockets, Streams, SMTP, etc. Core transport layer used in https://github.com/vapor/vapor"
HOMEPAGE="https://github.com/vapor/engine"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/engine.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Core
	dev-swift/Crypto
	dev-swift/TLS
	dev-swift/Sockets"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	--verbose \
	-Xlinker -L/usr/lib/swift/linux \
        -Xlinker -lTLS \
        -Xlinker -lSockets \
        -Xlinker -lCrypto \
        -Xlinker -lCore || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
        mkdir -p ${D}/usr/lib/swift/CHTTP || die
        cp .build/release/CHTTP.build/module.modulemap ${D}/usr/lib/swift/CHTTP || die
        sed -i -e 's|'${S}'/Sources/CHTTP/include|/usr/lib/swift/CHTTP|g' ${D}/usr/lib/swift/CHTTP/module.modulemap || die
	cp Sources/CHTTP/include/http_parser.h ${D}/usr/lib/swift/CHTTP || die
}
