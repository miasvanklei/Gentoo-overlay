# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="The Swift Programming Language"
HOMEPAGE="https://github.com/apple/swift"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift.git"
EGIT_BRANCH="master-next"
EGIT_COMMIT="112a63f3d1b01174bdaa7fe28269b2330ae3d9ab"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+sourcekit"

RDEPEND="
	app-text/cmark
	sys-libs/zlib
	dev-libs/libbsd
	dev-libs/icu:=
	sys-libs/ncurses
	=sys-devel/clang-6.0.0:=[swift]
        =sys-devel/llvm-6.0.0:=[swift]
	sourcekit? ( dev-libs/libdispatch )"
PDEPEND=""
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# we prefer own optimization
	eapply "${FILESDIR}"/fix-cflags.patch

	# use llvm-config
	eapply "${FILESDIR}"/swift-standalone.patch

	# assumes glibc
	eapply "${FILESDIR}"/musl-fixes.patch
	eapply "${FILESDIR}"/define-_GNU_SOURCE.patch
	eapply "${FILESDIR}"/glibc-modulemap.patch

	# do not install headers from clang multiple times
	eapply "${FILESDIR}"/fix-garbage.patch

	# strip when needed, call export-dynamic, etc.
	eapply "${FILESDIR}"/fix-toolchain.patch

	# link with some llvm libraries and cmark
	eapply "${FILESDIR}"/fix-linking.patch

	# remove __gnu_objc_personality_v0 by building Reflection.mm with -fno-exceptions
	eapply "${FILESDIR}"/remove-dep-libobjc.patch

	# build swiftGlibc as well when sdk is disabled
	eapply "${FILESDIR}"/enable-platform.patch

	# fix linking
	eapply "${FILESDIR}"/sourcekitd-standalone.patch

	# install files: libraries, headers, cmake
	eapply "${FILESDIR}"/install-files.patch

	# fix triple with arm, swift, llvm, clang, lldb
	eapply "${FILESDIR}"/arm-swift.patch

	# fix compile
	eapply "${FILESDIR}"/fix-compile.patch

	cmake-utils_src_prepare
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DLLVM_LINK_LLVM_DYLIB=ON

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON

		-DSWIFT_HOST_TRIPLE=${CHOST}
		-DSWIFT_COMPILER_VERSION=4.1
		-DCLANG_COMPILER_VERSION=5.0

		# Does not work, no benefit at all
		-DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=FALSE

		# build static as well
		-DSWIFT_BUILD_STATIC_STDLIB=TRUE

		# fail both right now
		-DSWIFT_INCLUDE_DOCS=FALSE
		-DSWIFT_INCLUDE_TESTS=FALSE
	)

	if use sourcekit; then
		mycmakeargs+=(
			-DSWIFT_BUILD_SOURCEKIT=$(usex sourcekit)
			-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY=$(usex sourcekit)
			-DHAVE_DISPATCH_BLOCK_CREATE=$(usex sourcekit)
		)
	fi

	cmake-utils_src_configure
}
