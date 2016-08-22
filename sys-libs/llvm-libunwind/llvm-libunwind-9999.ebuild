# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
EGIT_REPO_URI="https://github.com/llvm-mirror/libunwind.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-libs"

DEPEND=""
RDEPEND="!sys-libs/libunwind"

src_prepare() {
	default
	eapply "${FILESDIR}"/unwind-fix-missing-condition-encoding.patch
	eapply "${FILESDIR}"/revert-alignedment-commit.patch
	eapply "${FILESDIR}"/llvm-libunwind-3.9-cmake.patch
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		# work-around attempting to use llvm-config to get llvm sources
		# (that are not needed at all)
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {

        mkdir "${D}"/usr/include
        cp -r "${S}"/include/* "${D}"/usr/include || die
}
