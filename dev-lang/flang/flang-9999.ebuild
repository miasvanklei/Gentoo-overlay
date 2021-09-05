# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_9 )

inherit cmake git-r3

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
	dev-libs/libpgmath
	>=sys-devel/llvm-3.9
	>=sys-devel/clang-3.9
	${PYTHON_DEPS}"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/fix-build.patch
	"${FILESDIR}"/fix-compile.patch
)

src_configure()
{
	local mycmakeargs=(
		-DWITH_WERROR=OFF
		-DCMAKE_Fortran_COMPILER_ID=Flang
		-DFLANG_LLVM_EXTENSIONS=ON
	)

	cmake_src_configure
}
