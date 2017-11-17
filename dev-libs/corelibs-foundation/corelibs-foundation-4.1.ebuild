# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
CMAKE_IN_SOURCE_BUILD=TRUE

inherit git-r3 cmake-utils

DESCRIPTION="The Foundation Project, providing core utilities, internationalization, and OS independence"
HOMEPAGE="https://github.com/apple/swift-corelibs-foundation"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-foundation.git"
EGIT_BRANCH="swift-4.1-branch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
	dev-libs/icu
	sys-libs/zlib
        dev-lang/swift
	dev-libs/openssl
	net-nds/openldap
	elibc_musl? ( sys-libs/fts-standalone )
	net-misc/curl
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-lang/python:2.7"

src_prepare() {
	eapply "${FILESDIR}"/fix-build.patch
	eapply_user
}


src_configure() {
	export DSTROOT=${D}
	export SWIFT_TARGET=${CHOST}
	export LIBDISPATCH_SOURCE_DIR=/usr/lib/swift
	econf --target=${CHOST} release
}
