# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="New implementation of low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
EGIT_REPO_URI="https://github.com/llvm-mirror/libcxxabi.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libunwind +static-libs"

DEPEND="libunwind? ( ~sys-libs/llvm-libunwind-${PV}[static-libs?,${MULTILIB_USEDEP}] )
	~sys-libs/libcxx-${PV}[static-libs?,${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eapply "${FILESDIR}/libcxxabi-3.9-cmake.patch"
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXXABI_USE_COMPILER_RT=ON
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_LIBCXX_INCLUDES="/usr/include/c++/v1"
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
#		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}/usr/include/llvm-libunwind"
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	insinto "/usr/include/${PN}/"
	doins include/*
}
