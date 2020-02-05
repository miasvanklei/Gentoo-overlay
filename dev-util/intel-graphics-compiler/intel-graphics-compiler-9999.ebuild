# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit git-r3 cmake-multilib llvm

DESCRIPTION="LLVM-based OpenCL compiler targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI=""
EGIT_REPO_URI="https://github.com/intel/intel-graphics-compiler.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON="sys-devel/llvm:10=[${MULTILIB_USEDEP}]
	dev-libs/opencl-clang:10=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

LLVM_MAX_SLOT=10

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9-no_Werror.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_LIBRARY_PATH=$(get_llvm_prefix ${LLVM_MAX_SLOT})/$(get_libdir)
		-DIGC_OPTION__FORCE_SYSTEM_LLVM=ON
		-DIGC_PREFERRED_LLVM_VERSION=${LLVM_MAX_SLOT}
	)
	cmake_src_configure
}
