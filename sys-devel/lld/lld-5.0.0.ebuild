# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils llvm python-any-r1 git-r3

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="http://llvm.org/"
EGIT_REPO_URI="https://git.llvm.org/git/lld.git
        https://github.com/llvm-mirror/lld.git"
EGIT_BRANCH="release_50"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

S=${WORKDIR}/${P/_/}

# least intrusive of all
CMAKE_BUILD_TYPE=Release

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
        if use test; then
                # needed for patched gtest
                git-r3_fetch "https://git.llvm.org/git/llvm.git
                        https://github.com/llvm-mirror/llvm.git"
        fi
        git-r3_fetch

        if use test; then
                git-r3_checkout https://llvm.org/git/llvm.git \
                        "${WORKDIR}"/llvm
        fi
        git-r3_checkout
}

src_prepare() {
	# strip in lld, including comment section
	eapply "${FILESDIR}"/0001-strip-lld.patch

	# add -z muldefs
	eapply "${FILESDIR}"/0002-add-muldefs-option.patch

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON

		-DLLVM_INCLUDE_TESTS=$(usex test)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make check-lld
}

src_install() {
	cmake-utils_src_install

	# binutils symlinks
	dosym "/usr/bin/lld" "/usr/bin/${CHOST}-lld"
	dosym "/usr/bin/lld" "/usr/bin/${CHOST}-ld.lld"
	dosym "/usr/bin/lld" "/usr/bin/${CHOST}-ld"
	dosym "/usr/bin/lld" "/usr/bin/ld"
}
