# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
inherit cmake llvm llvm.org multilib python-single-r1

DESCRIPTION="Multi-Level IR Compiler Framework"
HOMEPAGE="https://mlir.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	~sys-devel/llvm-${PV}
	~sys-devel/clang-${PV}
	~dev-util/mlir-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/mlir:${LLVM_MAJOR}
	>=dev-util/cmake-3.16"

LLVM_COMPONENTS=( flang cmake )
LLVM_USE_TARGETS=provide
llvm.org_set_globals

PATCHES=(
	"${FILESDIR}/fix-finding-mlir-tblgen.patch"
)

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
}

src_configure() {
	local llvmdir="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${llvmdir}
		-DLLVM_DIR=${llvmdir}/lib/cmake/llvm
		-DCLANG_DIR=${llvmdir}/lib/cmake/clang
		-DMLIR_DIR=${llvmdir}/lib/cmake/mlir

                -DBUILD_SHARED_LIBS=OFF
                -DLLVM_LINK_LLVM_DYLIB=ON
		-DCLANG_LINK_CLANG_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DFLANG_INCLUDE_TESTS=OFF
	)

	cmake_src_configure
}

src_compile() {
	MAKEOPTS="-j12" cmake_src_compile
}

src_install() {
	cmake_src_install

	# Apply CHOST to flang tools
	local flang_tools=( gfortran flang )
        local abi i

	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${flang_tools[@]}"; do
			dosym "flang-new" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${abi_chost}-${i}"
			dosym "flang-new" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}"
		done
	done

	insinto /etc/clang
	newins - "flang.cfg" <<-EOF
		# This configuration file is used by flang driver.
		@gentoo-runtimes.cfg
		@gentoo-gcc-install.cfg
		@gentoo-hardened.cfg
	EOF
}
