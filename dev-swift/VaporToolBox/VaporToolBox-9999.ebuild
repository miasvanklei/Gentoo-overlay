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
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
        dev-swift/Bits
        dev-swift/Core
        dev-swift/CloudModels
        dev-swift/CloudClients
        dev-swift/Console
        dev-swift/JSON
        dev-swift/Node
        dev-swift/Vapor
        dev-swift/Redis
        dev-swift/Sockets"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
	${FILESDIR}/corelibs-foundation.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lBits \
	-Xlinker -lCore \
	-Xlinker -lCloudClients \
	-Xlinker -lCloudModels \
	-Xlinker -lConsole \
	-Xlinker -lHTTP \
	-Xlinker -lJSON \
	-Xlinker -lNode \
	-Xlinker -lVapor \
	-Xlinker -lRedis \
	-Xlinker -lSockets \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/bin || die
        cp .build/release/Executable ${D}/usr/bin/vapor || die
}
