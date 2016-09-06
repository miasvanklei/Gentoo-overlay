# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-multilib toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"

EGIT_REPO_URI="https://github.com/llvm-mirror/libcxx.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+experimental -libcxxrt +libunwind +static-libs"

RDEPEND="libcxxrt? ( >=sys-libs/libcxxrt-0.0_p20130725[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxrt? ( ~sys-libs/libcxxabi-${PV}[libunwind=,static-libs?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

DOCS=( CREDITS.TXT )

multilib_src_configure() {
	local libdir=$(get_libdir)
	local cxxabi=$(usex libcxxrt libcxxrt libcxxabi)

	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${EPREFIX}/usr/include/${cxxabi}"
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=$(usex !libunwind)
		-DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
