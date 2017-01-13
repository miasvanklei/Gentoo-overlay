# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python3_5 )

inherit cmake-multilib git-r3

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
EGIT_REPO_URI="http://llvm.org/git/libcxxabi.git
        https://github.com/llvm-mirror/libcxxabi.git"
EGIT_BRANCH="release_40"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compiler-rt +static-libs"

DEPEND="sys-libs/libunwind[static-libs?,${MULTILIB_USEDEP}]
	compiler-rt? ( ~sys-libs/compiler-rt-${PV} )
	~sys-libs/libcxx-${PV}[static-libs?,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

src_configure() {
	NATIVE_LIBDIR=$(get_libdir)
	cmake-multilib_src_configure
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${NATIVE_LIBDIR#lib}
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_COMPILER_RT==$(usex compiler-rt)
		-DLIBCXXABI_LIBCXX_INCLUDES="/usr/include/c++/v1"
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON
		# this only needs to exist, it does not have to make sense
		-DLIBCXXABI_LIBUNWIND_SOURCES="${T}"
		-DLIBCXXABI_LIBUNWIND_INCLUDES_INTERNAL="${T}"
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	insinto "/usr/include/${PN}/"
	doins -r include/*
}
