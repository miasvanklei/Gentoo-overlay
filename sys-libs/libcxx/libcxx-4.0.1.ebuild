# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+experimental +libunwind +static-libs"

RDEPEND="~sys-libs/libcxxabi-${PV}[libunwind=,static-libs?,${MULTILIB_USEDEP}]"
# LLVM 4 required for llvm-config --cmakedir
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-devel/llvm-4"

DOCS=( CREDITS.TXT )

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/${P/_/}.src

src_configure() {
	NATIVE_LIBDIR=$(get_libdir)
	cmake-multilib_src_configure
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local libcompiler_rt=$(clang -print-libgcc-file-name)
	local libunwind=$(usex libunwind "-lunwind" "")

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
		-DCMAKE_SHARED_LINKER_FLAGS="${libunwind} ${libcompiler_rt}"
	)
	cmake-utils_src_configure
}
