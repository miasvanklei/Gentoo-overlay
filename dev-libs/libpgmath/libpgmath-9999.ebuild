# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

inherit cmake-utils git-r3

DESCRIPTION="flang runtime math library"
HOMEPAGE="https://github.com/flang-compiler/flang"
SRC_URI=""
EGIT_REPO_URI="https://github.com/flang-compiler/flang.git"

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/fix-build.patch
	"${FILESDIR}"/fenv.patch
)

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/${P}/runtime/libpgmath

pkg_pretend() {
	if use arm64 && [ -z ${MCPU} ]; then
		eerror "please set MCPU to your -mcpu target, without -mcpu"
	fi
}

src_configure() {
	local mycmakeargs=()

	if use arm64; then
		mycmakeargs+=(
			-DLLVM_FLANG_CPU_TARGET=${MCPU}
		)
	fi

	cmake-utils_src_configure
}
