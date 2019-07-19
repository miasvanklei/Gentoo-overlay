# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit cmake-utils git-r3 llvm multiprocessing python-any-r1

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"
EGIT_BRANCH="release/9.x"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

S="${WORKDIR}/${PN}"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' "${WORKDIR}" '' lld

	if use test; then
		git-r3_checkout '' "${WORKDIR}" '' llvm/utils/{lit,unittest}
	fi
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_LINK_LLVM_DYLIB=ON
                -DLLVM_DYLIB_COMPONENTS="all"

		-DLLVM_INCLUDE_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make check-lld
}

src_install() {
	cmake-utils_src_install

	# binutils symlinks
	dosym "lld" "/usr/bin/${CHOST}-lld"
	dosym "lld" "/usr/bin/${CHOST}-ld.lld"
	dosym "lld" "/usr/bin/${CHOST}-ld"
	dosym "lld" "/usr/bin/ld"
}
