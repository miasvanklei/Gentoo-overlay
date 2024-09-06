# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
inherit cmake llvm llvm.org python-single-r1

DESCRIPTION="Multi-Level IR Compiler Framework"
HOMEPAGE="https://mlir.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="debug python test"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	~sys-devel/llvm-${PV}
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/llvm:${LLVM_MAJOR}
	python? ( ${PYTHON_DEPS} )
	test? (
		~dev-python/lit-${PV}
	)"

PATCHES=(
	"${FILESDIR}/fix-include-order.patch"
)

LLVM_COMPONENTS=( mlir cmake )
LLVM_USE_TARGETS=provide
llvm.org_set_globals

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"

                -DBUILD_SHARED_LIBS=OFF
                -DLLVM_BUILD_LLVM_DYLIB=ON
                -DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)

		-DMLIR_INSTALL_AGGREGATE_OBJECTS=0
		-DMLIR_INCLUDE_TESTS=$(usex test)
		-DMLIR_ENABLE_BINDINGS_PYTHON=$(usex python)
	)

	use python && mycmakeargs+=(
		-DPython3_EXECUTABLE="${PYTHON}"
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
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-mlir
}
