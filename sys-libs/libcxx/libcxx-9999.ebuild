# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib toolchain-funcs git-r3

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/libcxx.git
        https://github.com/llvm-mirror/libcxx.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+compiler-rt +experimental +libunwind +static-libs"

RDEPEND="~sys-libs/libcxxabi-9999[libunwind=,static-libs?,${MULTILIB_USEDEP}]
	compiler-rt? ( ~sys-libs/compiler-rt-4.0.0 )"
# LLVM 4 required for llvm-config --cmakedir
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-devel/llvm-4"

DOCS=( CREDITS.TXT )

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/fix-cflags.patch
)

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
		-DLIBCXX_USE_COMPILER_RT=$(usex compiler-rt)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
	)
	cmake-utils_src_configure
}
