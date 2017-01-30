# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib toolchain-funcs git-r3

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/libcxx.git
        https://github.com/llvm-mirror/libcxx.git"
EGIT_BRANCH="release_40"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+experimental +libunwind +static-libs"

RDEPEND="~sys-libs/libcxxabi-${PV}[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-devel/clang-3.9.0"

DOCS=( CREDITS.TXT )

src_configure() {
	NATIVE_LIBDIR=$(get_libdir)
	cmake-multilib_src_configure
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${NATIVE_LIBDIR#lib}
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${EPREFIX}/usr/include/libcxxabi"
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=$(usex !libunwind)
		-DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DCMAKE_SHARED_LINKER_FLAGS=$(usex libunwind "-lunwind" "")
	)
	cmake-utils_src_configure
}
