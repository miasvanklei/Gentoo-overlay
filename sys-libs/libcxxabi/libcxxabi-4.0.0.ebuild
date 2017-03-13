# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libunwind +compiler-rt +static-libs"

RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)"
# LLVM 4 required for llvm-config --cmakedir
DEPEND="${RDEPEND}
	>=sys-devel/llvm-4
	compiler-rt? ( ~sys-libs/compiler-rt-${PV} )
	~sys-libs/libcxx-${PV}[static-libs?,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/${P/_/}.src

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
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
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
