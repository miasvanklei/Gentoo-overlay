# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-multilib flag-o-matic llvm

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI=""
EGIT_REPO_URI="https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git"
EGIT_BRANCH="llvm_release_100"

LICENSE="UoI-NCSA"
SLOT="9"
KEYWORDS="~amd64"
IUSE="test tools"

COMMON="sys-devel/llvm:10=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}
	test? ( dev-python/lit )"
RDEPEND="${COMMON}"

REQUIRED_USE="test? ( tools )"

LLVM_MAX_SLOT=10

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0.1-no_pkgconfig_files.patch
)

src_prepare() {
#	append-flags -fPIC
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DLLVM_BUILD_TOOLS=$(usex tools "ON" "OFF")
		$(usex test "-DLLVM_INCLUDE_TESTS=ON" "")
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	# TODO: figure out why some tests fail on amd64 when ABI==x86
	if multilib_is_native_abi; then
		lit "${BUILD_DIR}/test" || die "Error running tests for ABI ${ABI}"
	fi
}
