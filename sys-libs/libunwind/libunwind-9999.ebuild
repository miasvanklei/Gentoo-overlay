# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libunwind/libunwind-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=6

inherit cmake-utils multilib-minimal git-r3

EGIT_REPO_URI="http://llvm.org/git/libunwind.git"

DESCRIPTION="unwind library"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND=""

src_prepare() {
	eapply "${FILESDIR}"/unwind-fix-missing-condition-encoding.patch
	eapply "${FILESDIR}"/libunwind-3.8-cmake.patch
	eapply "${FILESDIR}"/revert-alignedment-commit.patch
	eapply_user
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_CONFIG=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_BUILT_STANDALONE=ON
		-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=OFF
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

        mkdir "${D}"/usr/include
        cp -r "${S}"/include/* "${D}"/usr/include || die
}
