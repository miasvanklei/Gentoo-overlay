# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="The XCTest Project, A Swift core library for providing unit test support"
HOMEPAGE="https://github.com/apple/swift-corelibs-xctest"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-xctest.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
	dev-libs/icu
	dev-lang/swift
	dev-libs/corelibs-foundation
	sys-libs/zlib
	dev-libs/openssl
	net-nds/openldap
	elibc_musl? ( sys-libs/fts-standalone )
	net-misc/curl
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

src_install() {
	./build_script.py \
	--swiftc /usr/bin/swiftc \
	--foundation-build-dir / \
	--library-install-path ${D}/usr/lib/swift/linux \
	--module-install-path ${D}/usr/lib/swift/linux/x86_64 || die
}
