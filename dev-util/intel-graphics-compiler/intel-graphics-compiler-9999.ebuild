# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib llvm git-r3

DESCRIPTION="LLVM-based OpenCL compiler targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI=""
EGIT_REPO_URI="https://github.com/intel/intel-graphics-compiler.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON="sys-devel/llvm:9=[${MULTILIB_USEDEP}]
	>=dev-libs/opencl-clang-9.0.0:9=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

LLVM_MAX_SLOT=9
CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9-no_Werror.patch
	"${FILESDIR}"/fix-compile.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_LIBRARY_PATH=$(get_llvm_prefix)/$(get_libdir)
		-DIGC_OPTION__FORCE_SYSTEM_LLVM=ON
		-DIGC_PREFERRED_LLVM_VERSION=9
	)
	cmake-utils_src_configure
}
