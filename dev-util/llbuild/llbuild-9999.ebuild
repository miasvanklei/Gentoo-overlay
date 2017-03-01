# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3

inherit cmake-utils git-r3

DESCRIPTION="A low-level build system, used by the Swift Package Manager"
HOMEPAGE="https://github.com/apple/swift-llbuild"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-llbuild.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-devel/llvm
	dev-lang/swift
	sys-libs/ncurses
	dev-db/sqlite
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/fix-cmake.patch
	eapply ${FILESDIR}/fix-conversion.patch
	eapply ${FILESDIR}/fix-includes.patch
	eapply ${FILESDIR}/remove-lit.patch
	eapply_user
}

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
