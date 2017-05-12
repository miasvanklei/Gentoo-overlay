# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="SQLite 3 wrapper for swift"
HOMEPAGE="https://github.com/vapor-community/sqlite.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor-community/sqlite.git"
EGIT_COMMIT="f8ff964ca464ea0812c07c874826c9d00dca629a"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Core
	dev-swift/Node"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lNode \
	-Xlinker -lCore || die
}

src_install() {
	mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
	cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
	cp .build/release/lib* ${D}/usr/lib/swift/linux || die
}
