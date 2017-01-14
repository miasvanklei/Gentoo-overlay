# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3

inherit cmake-utils git-r3

DESCRIPTION="The Swift Programming Language"
HOMEPAGE="https://github.com/apple/swift"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="lldb"

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

	# segfault in clang
	eapply ${FILESDIR}/fix-segfault.patch

	# can probably be removed later on
	eapply ${FILESDIR}/fix-segfault-1.patch

	# do not install headers from clang multiple times
	eapply ${FILESDIR}/fix-garbage.patch

	# strip when needed, call export-dynamic, etc.
	eapply ${FILESDIR}/fix-toolchain.patch

	# fix build: missing llvm libraries and use libobjc
	eapply ${FILESDIR}/fix-linking.patch

	# use same code as on darwin
	eapply ${FILESDIR}/sourcekitd-fixes.patch

	# let it build with llvm/clang 4.0
	eapply ${FILESDIR}/llvm-clang-4.0.patch

	# wcslcat is in libbsd, otherwise no sourcekitd-repl
	eapply ${FILESDIR}/have-libedit.patch

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
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use lldb; then
		# copy libraries
		cp -r ${BUILD_DIR}/lib/*.a ${D}/usr/lib

		# copy headers
		mkdir -p ${D}/usr/include/swift/IRGen || die
		pushd ${S}/include/swift >/dev/null
       		find . -name "*.h" -type f -exec cp --parents {} ${D}/usr/include/swift \; || die
        	find . -name "*.def" -type f -exec cp --parents {} ${D}/usr/include/swift \; || die
		popd >/dev/null
		cp -r ${S}/lib/IRGen/*.h ${D}/usr/include/swift/IRGen || die

		# copy cmake files
		mkdir -p ${D}/usr/lib/cmake/swift || die
		cp ${S}/cmake/modules/SwiftAddCustomCommandTarget.cmake ${D}/usr/lib/cmake/swift || die
		cp ${S}/cmake/modules/SwiftUtils.cmake ${D}/usr/lib/cmake/swift || die
	fi
}
