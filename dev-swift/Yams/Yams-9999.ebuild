# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="A Sweet and Swifty YAML parser."
HOMEPAGE="https://github.com/jpsim/Yams"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jpsim/Yams.git"

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
        eapply ${FILESDIR}/fix-compilation.patch
        eapply ${FILESDIR}/foundation.patch
        eapply ${FILESDIR}/install-lib.patch
        eapply_user
}

src_compile() {
	swift build --verbose \
	-c release || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
	mkdir ${D}/usr/lib/swift/CYaml || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib* ${D}/usr/lib/swift/linux || die
	cp .build/release/CYaml.build/module.modulemap ${D}/usr/lib/swift/CYaml || die
	cp Sources/CYaml/include/yaml.h ${D}/usr/lib/swift/CYaml/CYaml.h || die
	sed -i -e 's|'${S}'/Sources/CYaml/include|/usr/lib/swift/CYaml|g' ${D}/usr/lib/swift/CYaml/module.modulemap || die
}
