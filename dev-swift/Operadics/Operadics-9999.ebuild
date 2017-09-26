# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="QuickCheck for Swift"
HOMEPAGE="https://github.com/typelift/Operadics"
SRC_URI=""
EGIT_REPO_URI="https://github.com/typelift/Operadics"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-util/swift-package-manager"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build --verbose \
	-c release || die
}

src_install() {
	mkdir -p ${D}/usr/lib/swift/linux/${CARCH} || die
	cp .build/release/*.swift* ${D}/usr/lib/swift/linux/${CARCH} || die
	cp .build/release/lib* ${D}/usr/lib/swift/linux || die
}
