# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 20 )

inherit cmake-multilib git-r3 flag-o-matic llvm-r1 multiprocessing

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
EGIT_REPO_URI="https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git"
EGIT_BRANCH="llvm_release_200"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-tools[${MULTILIB_USEDEP}]
	sys-devel/llvm:${SLOT}=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/spirv-headers-1.3.280
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lit
		sys-devel/clang:${SLOT}
	)
"

PATCHES=(
)

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare

	# https://github.com/KhronosGroup/SPIRV-LLVM-Translator/pull/2555
	sed -i -e 's/%triple/x86_64-unknown-linux-gnu/' test/DebugInfo/X86/*.ll || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/include/spirv"
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

multilib_src_test() {
	lit -vv "-j${LIT_JOBS:-$(makeopts_jobs)}" "${BUILD_DIR}/test" || die
}
