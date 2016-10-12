# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug libedit python ncurses doc"

RDEPEND="
	~sys-devel/llvm-${PV}:=[debug=,ncurses]
	~sys-devel/clang-${PV}:=[debug=]
	dev-python/six[${PYTHON_USEDEP}]
	!<sys-devel/llvm-${PV}
	${PYTHON_DEPS}"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	dev-lang/swig
	doc? ( dev-python/sphinx )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${P/_}.src

src_prepare() {
	python_setup

	eapply "${FILESDIR}"/lldb-fix-getopt.patch
	eapply "${FILESDIR}"/fix-regex-impl.patch

	# Do not install dummy readline.so module from
	# https://llvm.org/bugs/show_bug.cgi?id=18841
	sed -e 's/add_subdirectory(readline)/#&/' \
		-i scripts/Python/modules/CMakeLists.txt || die
	# Do not install bundled six module
	eapply "${FILESDIR}"/six.patch

	# User patches
	eapply_user
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLLVM_ENABLE_EH=ON
                -DLLVM_ENABLE_RTTI=ON
                -DLLVM_ENABLE_CXX1Y=ON
                -DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLDB_EXPORT_ALL_SYMBOLS=ON
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
		-DLLDB_DISABLE_PYTHON=$(usex !python)
		-DLLDB_DISABLE_CURSES=$(usex !ncurses)
	)

	cmake-utils_src_configure
}
