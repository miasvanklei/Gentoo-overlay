# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="The Swift Programming Language"
HOMEPAGE="https://github.com/apple/swift"
SRC_URI="https://github.com/apple/${PN}/archive/${P}-RELEASE.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+lldb"

RDEPEND="
	app-text/cmark
	sys-libs/zlib
	dev-libs/libbsd
	sys-libs/ncurses
	>sys-devel/clang-3.9.0
	>sys-devel/llvm-3.9.0
	gnustep-base/libobjc2
	lldb? ( >dev-util/lldb-3.9.0 )"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/swift-swift-3.1-RELEASE

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

	# segfault in clang: SWIFT_DEFER
	eapply ${FILESDIR}/fix-segfault.patch

	# do not install headers from clang multiple times
	eapply ${FILESDIR}/fix-garbage.patch

	# strip when needed, call export-dynamic, etc.
	eapply ${FILESDIR}/fix-toolchain.patch

	# fix build: missing llvm libraries and use libobjc
	eapply ${FILESDIR}/fix-linking.patch

	# use same code as on darwin
	eapply ${FILESDIR}/sourcekitd-fixes.patch

	# wcslcat is in libbsd, otherwise no sourcekitd-repl
	eapply ${FILESDIR}/wcslcat.patch

	# install files: libraries, headers, cmake
	eapply ${FILESDIR}/install-files.patch

	# llvm/clang 4.0 patch
	eapply ${FILESDIR}/llvm-clang-4.0.patch

	# fix use in libdispatch
	eapply ${FILESDIR}/fix-attribute.patch

	default
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
                -DBUILD_SHARED_LIBS=ON

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DCMARK_LIBRARY_DIR=/usr/lib
		-DSWIFT_HOST_TRIPLE=${CHOST}
		-DSWIFT_BUILD_SOURCEKIT=TRUE
		-DSWIFT_SOURCEKIT_USE_INPROC_LIBRARY=TRUE
		-DHAVE_DISPATCH_BLOCK_CREATE=TRUE
		-DSWIFT_COMPILER_VERSION=3.1
		-DCLANG_COMPILER_VERSION=4.0
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# needed when using musl
	insinto /usr/include/swift
	doins ${FILESDIR}/Macros.h
}
