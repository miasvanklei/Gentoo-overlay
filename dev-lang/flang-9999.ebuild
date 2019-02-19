# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

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
	sys-libs/libpgmath
	${PYTHON_DEPS}"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	${FILESDIR}/fix-compile.patch
	${FILESDIR}/llvm-7.0.patch
)

src_configure() {
	local mycmakeargs=(
		-DTARGET_ARCHITECTURE=${CBUILD%%-*}
	)
	cmake-utils_src_configure
}
