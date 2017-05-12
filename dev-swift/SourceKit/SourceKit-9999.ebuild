# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="SourceKit header"
HOMEPAGE="https://github.com/norio-nomura/SourceKit"
SRC_URI=""
EGIT_REPO_URI="https://github.com/norio-nomura/SourceKit.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/lib/swift/SourceKit || die
	cp module.modulemap ${D}/usr/lib/swift/SourceKit || die
	cp sourcekitd.h ${D}/usr/lib/swift/SourceKit || die
}
