# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A web framework and server for Swift that works on macOS and Ubuntu. https://vapor.codes"
HOMEPAGE="https://github.com/vapor/vapor.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/vapor.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Engine
	dev-swift/Console
	dev-swift/JSON
	dev-swift/Routing
	dev-swift/Multipart
	dev-swift/BCrypt"
DEPEND="${RDEPEND}"

PATCHES=(
        ${FILESDIR}/fix-compile.patch
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lCore \
	-Xlinker -lBCrypt \
	-Xlinker -lConsole \
	-Xlinker -lCookies \
	-Xlinker -lCrypto \
	-Xlinker -lFormData \
	-Xlinker -lHTTP \
	-Xlinker -lJSON \
	-Xlinker -lMultipart \
	-Xlinker -lNode \
	-Xlinker -lRouting \
	-Xlinker -lSMTP \
	-Xlinker -lWebSockets \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
