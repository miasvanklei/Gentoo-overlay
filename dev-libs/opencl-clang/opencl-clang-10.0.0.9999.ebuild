# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-multilib llvm

DESCRIPTION="OpenCL-oriented thin wrapper library around clang"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI=""
EGIT_REPO_URI="https://github.com/intel/opencl-clang.git"
EGIT_BRANCH="ocl-open-100"

LLVM_MAX_SLOT=10

LICENSE="UoI-NCSA"
SLOT="${LLVM_MAX_SLOT}"
KEYWORDS="~amd64"

DEPEND="sys-devel/clang:${LLVM_MAX_SLOT}=[static-analyzer,${MULTILIB_USEDEP}]
	dev-util/spirv-llvm-translator:${LLVM_MAX_SLOT}=[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0-clang_library_dir.patch
	"${FILESDIR}"/link-with-clang-cpp.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DCLANG_LIBRARY_DIRS="${EPREFIX}"/usr/lib/clang
	)
	cmake-utils_src_configure
}
