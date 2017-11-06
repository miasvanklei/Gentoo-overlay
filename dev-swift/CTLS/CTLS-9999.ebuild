# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="LibreSSL / OpenSSL module map for Swift"
HOMEPAGE="https://github.com/vapor/ctls"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor/ctls.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/fix-shim-header.patch
)

src_install() {
	mkdir -p ${D}/usr/lib/swift/CTLS || die
	cp module.modulemap ${D}/usr/lib/swift/CTLS || die
	cp shim.h ${D}/usr/lib/swift/CTLS || die
}
