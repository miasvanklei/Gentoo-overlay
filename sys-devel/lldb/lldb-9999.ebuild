# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic multilib-minimal \
	python-single-r1 toolchain-funcs pax-utils git-r3

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/lldb.git
	https://github.com/llvm-mirror/lldb.git"
LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS=""
IUSE="debug libedit python ncurses doc"

RDEPEND="
	~sys-devel/llvm-${PV}:=[debug=,ncurses,${MULTILIB_USEDEP}]
	~sys-devel/clang-${PV}:=[debug=,${MULTILIB_USEDEP}]
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

pkg_pretend() {
	local build_size=650

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend

	python-single-r1_pkg_setup
}

src_prepare() {
	python_setup

	eapply "${FILESDIR}"/lldb-9999-fix-getopt.patch

	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLLVM_ENABLE_EH=ON
                -DLLVM_ENABLE_RTTI=ON
                -DLLVM_ENABLE_CXX1Y=ON
                -DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
		-DLLDB_DISABLE_CURSES=$(usex !ncurses)
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLDB_DISABLE_PYTHON=$(usex !python)
		)
	else
		mycmakeargs+=(
			# only run swig on native abi
			-DLLDB_DISABLE_PYTHON=ON
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		[[ -x "/usr/bin/llvm-tblgen" ]] \
			|| die "/usr/bin/llvm-tblgen not found or usable"

		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN=/usr/bin/llvm-tblgen
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-clang
}


multilib_src_install() {
	cmake-utils_src_install

}
