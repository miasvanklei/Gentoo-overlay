# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 git-r3

DESCRIPTION="The Swift Programming Language"
HOMEPAGE="https://github.com/apple/swift"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+lldb +sourcekit"

RDEPEND="
	app-text/cmark
	sys-libs/zlib
	dev-libs/libbsd
	dev-libs/icu
	sys-libs/ncurses
	=sys-devel/clang-5.0.0:=[swift]
        =sys-devel/llvm-5.0.0:=[swift]
	sourcekit? ( dev-libs/libdispatch )"
PDEPEND="lldb? ( =dev-util/lldb-5.0.0:=[libedit,python,swift] )"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# we prefer own optimization
	eapply ${FILESDIR}/fix-cflags.patch

	# some targets are not called
	eapply ${FILESDIR}/fix-build-cmake.patch

	# use llvm-config
	eapply ${FILESDIR}/standalone.patch

	# assumes glibc
	eapply ${FILESDIR}/musl-fixes.patch
	eapply ${FILESDIR}/glibc-modulemap.patch

	# incorrect c++ code
	eapply ${FILESDIR}/add-destructor.patch

	# do not install headers from clang multiple times
	eapply ${FILESDIR}/fix-garbage.patch

	# strip when needed, call export-dynamic, etc.
	eapply ${FILESDIR}/fix-toolchain.patch

	# link with some llvm libraries and cmark
	eapply ${FILESDIR}/fix-linking.patch

	# remove __gnu_objc_personality_v0 by building Reflection.mm with -fno-exceptions
	eapply ${FILESDIR}/remove-dep-libobjc.patch

	# fix linking
	eapply ${FILESDIR}/sourcekitd-fixes.patch

	# install files: libraries, headers, cmake
	eapply ${FILESDIR}/install-files.patch

	# fix triple with arm, swift, llvm, clang, lldb
	eapply ${FILESDIR}/arm-swift.patch

	# revert one patch to build with system llvm
	eapply ${FILESDIR}/llvm-5.0.patch

	default
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DSWIFT_HOST_TRIPLE=${CHOST}
		-DSWIFT_BUILD_SOURCEKIT=$(usex sourcekit)
		-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY=$(usex sourcekit)
		-DHAVE_DISPATCH_BLOCK_CREATE=$(usex sourcekit)
		-DSWIFT_COMPILER_VERSION=4.0
		-DCLANG_COMPILER_VERSION=5.0
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# needed when using musl
	insinto /usr/include/swift
	doins ${FILESDIR}/Macros.h
}
