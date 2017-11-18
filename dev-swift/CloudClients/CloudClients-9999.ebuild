# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Convenience protocols for working with API clients"
HOMEPAGE="https://github.com/vapor-cloud/clients"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor-cloud/clients.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Models
	dev-swift/JWT
	dev-swift/Vapor"
DEPEND="${RDEPEND}"

PATCHES=(
        ${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lCloudModels \
	-Xlinker -lHTTP \
	-Xlinker -lVapor \
	-Xlinker -lJWT \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
