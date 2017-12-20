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
EGIT_BRANCH="swift-4.1-branch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-devel/llvm
	dev-lang/swift
	sys-libs/ncurses
	dev-db/sqlite
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/fix-includes.patch
)
