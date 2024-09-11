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
	"${FILESDIR}/support-linking-libmlir.patch"
)

LLVM_COMPONENTS=( mlir cmake )
LLVM_USE_TARGETS=provide
llvm.org_set_globals

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

check_distribution_components() {
	if [[ ${CMAKE_MAKEFILE_GENERATOR} == ninja ]]; then
		local all_targets=() my_targets=() l
		cd "${BUILD_DIR}" || die

		while read -r l; do
			if [[ ${l} == install-*-stripped:* ]]; then
				l=${l#install-}
				l=${l%%-stripped*}

				case ${l} in
					# meta-targets
					mlir-libraries|distribution)
						continue
						;;
					# static libraries
					MLIR*)
						continue
						;;
				esac

				all_targets+=( "${l}" )
			fi
		done < <(${NINJA} -t targets all)

		while read -r l; do
			my_targets+=( "${l}" )
		done < <(get_distribution_components $"\n")

		local add=() remove=()
		for l in "${all_targets[@]}"; do
			if ! has "${l}" "${my_targets[@]}"; then
				add+=( "${l}" )
			fi
		done
		for l in "${my_targets[@]}"; do
			if ! has "${l}" "${all_targets[@]}"; then
				remove+=( "${l}" )
			fi
		done

		if [[ ${#add[@]} -gt 0 || ${#remove[@]} -gt 0 ]]; then
			eqawarn "get_distribution_components() is outdated!"
			eqawarn "   Add: ${add[*]}"
			eqawarn "Remove: ${remove[*]}"
		fi
		cd - >/dev/null || die
	fi
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		mlir-cmake-exports
		mlir-headers

		# shared libs
		MLIR-C
		MLIR
		#mlir_async_runtime
		#mlir_c_runner_utils
		#mlir_float16_utils
		#mlir_runner_utils

		# tools
		#mlir-cpu-runner
		#mlir-linalg-ods-yaml-gen
		#mlir-lsp-server
		#mlir-opt
		#mlir-pdll-lsp-server
		#mlir-reduce mlir-translate
		#tblgen-lsp-server

		# utilities
		#mlir-pdll
		mlir-tblgen
	)

	printf "%s${sep}" "${out[@]}"
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"

                -DBUILD_SHARED_LIBS=OFF
		-DMLIR_BUILD_MLIR_C_DYLIB=ON
		-DLLVM_BUILD_LLVM_DYLIB=ON
                -DLLVM_LINK_LLVM_DYLIB=ON
                -DMLIR_LINK_MLIR_DYLIB=ON
		-DLLVM_BUILD_UTILS=ON

		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DMLIR_INCLUDE_TESTS=$(usex test)
		-DMLIR_ENABLE_BINDINGS_PYTHON=$(usex python)

		# disabled for now
		-DLLVM_BUILD_TOOLS=OFF
		-DMLIR_ENABLE_CUDA_RUNNER=OFF
		-DMLIR_ENABLE_ROCM_RUNNER=OFF
		-DMLIR_ENABLE_SPIRV_CPU_RUNNER=OFF
		-DMLIR_ENABLE_VULKAN_RUNNER=OFF
		-DMLIR_ENABLE_BINDINGS_PYTHON=OFF
		-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF
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

src_compile() {
	cmake_build distribution
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-mlir
}

src_install() {
	DESTDIR=${D} cmake_build install-distribution
}
