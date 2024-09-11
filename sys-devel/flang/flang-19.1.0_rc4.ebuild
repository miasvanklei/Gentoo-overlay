# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
inherit cmake llvm llvm.org multilib python-single-r1

DESCRIPTION="Flang is LLVM’s Fortran frontend"
HOMEPAGE="https://flang.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="default-compiler-rt"

RDEPEND="
	~sys-devel/llvm-${PV}
	~sys-devel/clang-${PV}
	~dev-util/mlir-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/mlir:${LLVM_MAJOR}"

RDEPEND="
        ${PYTHON_DEPS}
        ${DEPEND}
        >=sys-devel/flang-common-${PV}
"
PDEPEND="
        >=sys-devel/flang-toolchain-symlinks-19:${LLVM_MAJOR}
"

LLVM_COMPONENTS=( flang cmake )
LLVM_USE_TARGETS=provide
llvm.org_set_globals

PATCHES=(
	"${FILESDIR}/fix-finding-mlir-tblgen.patch"
	"${FILESDIR}/missing-bessel-functions.patch"
)
#	"${FILESDIR}/support-linking-libmlir.patch"

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	local llvmdir="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${llvmdir}
		-DLLVM_DIR=${llvmdir}/lib/cmake/llvm
		-DCLANG_DIR=${llvmdir}/lib/cmake/clang
		-DMLIR_DIR=${llvmdir}/lib/cmake/mlir

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
