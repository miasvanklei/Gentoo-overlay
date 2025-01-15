# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake llvm.org llvm-utils python-single-r1

DESCRIPTION="Flang is LLVM’s Fortran frontend"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS="~amd64 ~arm64"
IUSE="default-compiler-rt"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	~llvm-core/llvm-${PV}
	~llvm-core/clang-${PV}
	~llvm-core/mlir-${PV}
"

RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
	>=llvm-core/flang-common-${PV}
"
BDEPEND="
	${PYTHON_DEPS}
"
PDEPEND="
	llvm-core/flang-toolchain-symlinks:${LLVM_MAJOR}
"

LLVM_COMPONENTS=( flang cmake openmp )
LLVM_USE_TARGETS=llvm
llvm.org_set_globals

PATCHES=(
	"${FILESDIR}/fix-finding-mlir-tblgen.patch"
	"${FILESDIR}/missing-bessel-functions.patch"
	"${FILESDIR}/support-linking-libmlir.patch"
	"${FILESDIR}/export-libomp-version.patch"
	"${FILESDIR}/fix-standalone-openmp-module-build.patch"
)

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	local llvmdir="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${llvmdir}"
		-DLLVM_DIR="${llvmdir}/lib/cmake/llvm"
		-DCLANG_DIR="${llvmdir}/lib/cmake/clang"
		-DMLIR_DIR="${llvmdir}/lib/cmake/mlir"
		-DOPENMP_RUNTIME_DIR="${WORKDIR}/openmp/runtime"

		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DCLANG_LINK_CLANG_DYLIB=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DFLANG_INCLUDE_TESTS=OFF
	)

	cmake_src_configure
}
