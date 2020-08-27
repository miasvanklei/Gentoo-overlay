# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_8 )
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils git-r3

DESCRIPTION="flang compiler"
HOMEPAGE="https://github.com/flang-compiler/flang"
SRC_URI=""
EGIT_REPO_URI="https://github.com/flang-compiler/flang.git"

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/llvm-3.9
	>=sys-devel/clang-3.9
	${PYTHON_DEPS}"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	${FILESDIR}/fix-compile.patch
	${FILESDIR}/fix-cpp.patch
	${FILESDIR}/fix-parallel-build.patch
	${FILESDIR}/fix-definition.patch
	${FILESDIR}/merged-build.patch
	${FILESDIR}/fenv.patch
)

pkg_pretend() {
        if use arm64 && [ -z ${MCPU} ]; then
                eerror "please set MCPU to your -mcpu target, without -mcpu"
        fi
}
src_configure() {
        local mycmakeargs=(
		 -DBUILD_SHARED_LIBS=OFF
	)
        if use arm64; then
                mycmakeargs+=(
                        -DLLVM_FLANG_CPU_TARGET=${MCPU}
                )
        fi
        cmake-utils_src_configure
}
