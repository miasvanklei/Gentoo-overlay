# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="LibreSSL wrapped in a Swift package."
HOMEPAGE="https://github.com/vapor/clibressl"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/clibressl.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-util/swift-package-manager"
DEPEND="${RDEPEND}"

src_compile() {
	swift build -c release \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/CLibreSSL || die
        mkdir -p ${D}/usr/lib/swift/linux || die
        cp -r Sources/CLibreSSL/include/*.h ${D}/usr/lib/swift/CLibreSSL || die
        cp .build/release/CLibreSSL.build/module.modulemap ${D}/usr/lib/swift/CLibreSSL || die
        sed -i -e 's|'${S}'/Sources/CLibreSSL/include|/usr/lib/swift/CLibreSSL|g' ${D}/usr/lib/swift/CLibreSSL/module.modulemap || die
        cp .build/release/lib*.so ${D}/usr/lib/swift/linux || die
}
