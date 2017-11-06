# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils git-r3 multilib

DESCRIPTION="The libdispatch Project, (a.k.a. Grand Central Dispatch), for concurrency on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-corelibs-libdispatch.git"
EGIT_BRANCH="swift-4.1-branch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+swift test"

RDEPEND="swift? ( dev-lang/swift )
	dev-libs/libbsd"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/fix-compile.patch
	${FILESDIR}/fix-segfault.patch
	${FILESDIR}/fix-cmake.patch
)

CMAKE_BUILD_TYPE=Release

src_configure() {
	local mycmakeargs=(
		-DUSE_GOLD_LINKER=OFF
		-DENABLE_TESTING=$(usex test)
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
		-DENABLE_DTRACE=false
	)

	if use swift; then
		mycmakeargs+=(
			-DCMAKE_SWIFT_COMPILER=/usr/bin/swiftc
			-DENABLE_SWIFT=TRUE
		)
	fi
	cmake-utils_src_configure
}
