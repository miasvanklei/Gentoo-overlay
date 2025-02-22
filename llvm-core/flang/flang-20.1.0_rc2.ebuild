# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm.org

DESCRIPTION="LLVM's Fortran frontend"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+debug test"
RESTRICT="!test? ( test )"

DEPEND="
	~llvm-core/clang-${PV}[debug=]
	~llvm-core/llvm-${PV}[debug=]
	~llvm-core/mlir-${PV}[debug=]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/lit
	)
"

PDEPEND="
	>=llvm-core/flang-toolchain-symlinks-20:${LLVM_MAJOR}
"

LLVM_COMPONENTS=( flang cmake openmp )
LLVM_TEST_COMPONENTS=( clang/test/Driver mlir/test/lib )
llvm.org_set_globals

PATCHES=(
	"${FILESDIR}/dont-install-flang-new.patch"
        "${FILESDIR}/fix-linking-libmlir.patch"
        "${FILESDIR}/export-libomp-version.patch"
        "${FILESDIR}/fix-standalone-openmp-module-build.patch"
	"${FILESDIR}/fix-build-libcxx.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"

		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCLANG_RESOURCE_DIR="../../../clang/${LLVM_MAJOR}"

		-DBUILD_SHARED_LIBS=OFF
		-DMLIR_LINK_MLIR_DYLIB=ON
		# flang does not feature a dylib, so do not install libraries
		# or headers
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

		# TODO: always enable to obtain reproducible tools
		-DFLANG_INCLUDE_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-flang
}
