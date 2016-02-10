# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit cmake-utils multilib-minimal git-r3

EGIT_REPO_URI="https://github.com/llvm-mirror/libcxx.git"

DESCRIPTION="c++ library from llvm"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND="sys-libs/libunwind
	 sys-libs/libcxxabi"

src_prepare() {
        epatch "${FILESDIR}"/remove-llvm-src.patch
	epatch "${FILESDIR}"/libcxx-fixes.patch
	epatch "${FILESDIR}"/libcxx-static-and-shared.patch
	epatch "${FILESDIR}"/libcxx-wrong-std.patch
}


multilib_src_configure() {
	local libdir=$(get_libdir)
        local mycmakeargs=(
                -DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
                -DLIBCXXABI_ENABLE_ASSERTIONS=OFF
                -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
                -DLIBCXX_HAS_MUSL_LIBC=ON
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=/usr/include
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}
