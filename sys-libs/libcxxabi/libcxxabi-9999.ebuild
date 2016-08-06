# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxxabi/libcxxabi-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit cmake-utils multilib-minimal git-r3

EGIT_REPO_URI="https://github.com/llvm-mirror/libcxxabi.git"

DESCRIPTION="libcxxabi library"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND="sys-libs/libunwind"

src_prepare() {
        epatch "${FILESDIR}"/remove-llvm-src.patch
        epatch "${FILESDIR}"/fix-configure.patch

	# copy libunwind headers, otherwise segfault
	cp  /usr/include/unwind.h "${S}"/src
	cp  /usr/include/libunwind.h "${S}"/src
	cp  /usr/include/__libunwind_config.h "${S}"/src
}


multilib_src_configure() {
	local libdir=$(get_libdir)
        local mycmakeargs=(
                -DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
                -DLIBCXXABI_ENABLE_ASSERTIONS=OFF
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON
		-DLIBCXXABI_USE_COMPILER_RT=ON
		-DLIBCXXABI_BUILT_STANDALONE=1
        )

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install

}

multilib_src_install_all() {
	mkdir -p "${D}"/usr/include/libc++abi
        cp -r "${S}"/include/* "${D}"/usr/include/libc++abi || die
}
