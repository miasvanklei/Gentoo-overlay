# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	~sys-devel/llvm-4.0.0
	~sys-devel/clang-4.0.0
	${PYTHON_DEPS}"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	${FILESDIR}/fix-compile.patch
)

src_configure() {
	local clang_version=4.0.0
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
