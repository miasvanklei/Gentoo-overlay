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
IUSE=""

RDEPEND="
	dev-libs/libcmark
	sys-libs/zlib
	sys-libs/ncurses
	~sys-devel/clang-${PV}[xml]
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/custom-build-type.patch
	eapply ${FILESDIR}/standalone.patch
	eapply ${FILESDIR}/llvm-4.0.patch
	eapply ${FILESDIR}/llvm-4.0-1.patch
	eapply ${FILESDIR}/musl-fixes.patch
	eapply ${FILESDIR}/add-destructor.patch
	eapply ${FILESDIR}/fix-segfault.patch
	eapply ${FILESDIR}/fix-modulemap.patch
	eapply ${FILESDIR}/fix-garbage.patch
	eapply ${FILESDIR}/fix-opaque-struct.patch
	eapply ${FILESDIR}/dont-set-linker.patch
	eapply ${FILESDIR}/fix-non-defined.patch
	eapply ${FILESDIR}/fix-dlopen.patch
	default
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_CXX1Y=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DCMARK_LIBRARY_DIR=/usr/lib
		-DSWIFT_HOST_TRIPLE=${CHOST}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
	# not called?
	cmake-utils_src_make swiftStdlibUnicodeUnittest-linux
	cmake-utils_src_make swiftStdlibCollectionUnittest-linux
}

src_install() {
	cmake-utils_src_install

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
}
