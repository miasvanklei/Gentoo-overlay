# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

MY_P="libunwind-${PV}"

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI="http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/${MY_P/_}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-libs"

DEPEND=""
RDEPEND="!sys-libs/libunwind"

S="${WORKDIR}/${MY_P/_}.src"

src_prepare() {
	default
	eapply "${FILESDIR}"/unwind-fix-missing-condition-encoding.patch
	eapply "${FILESDIR}"/libunwind-3.8-cmake.patch
	eapply "${FILESDIR}"/revert-alignedment-commit.patch
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		# work-around attempting to use llvm-config to get llvm sources
		# (that are not needed at all)
		-DLLVM_CONFIG=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_BUILT_STANDALONE=ON
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {

        mkdir "${D}"/usr/include
        cp -r "${S}"/include/* "${D}"/usr/include || die
}
