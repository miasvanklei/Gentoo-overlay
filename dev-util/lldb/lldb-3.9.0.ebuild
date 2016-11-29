# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1 toolchain-funcs

DESCRIPTION="The LLVM debugger"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm-mirror/lldb.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="+libedit +ncurses python test"

RDEPEND="
	dev-lang/swift
	libedit? ( dev-libs/libedit:0= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	python? ( dev-python/six[${PYTHON_USEDEP}]
		${PYTHON_DEPS} )
	~sys-devel/clang-${PV}[xml]
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-${PV}"
# swig-3.0.9+ generates invalid wrappers, #598708
# upstream: https://github.com/swig/swig/issues/769
DEPEND="${RDEPEND}
	python? ( <dev-lang/swig-3.0.9 )
	test? ( dev-python/lit[${PYTHON_USEDEP}] )
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	eapply ${FILESDIR}/0001-add-swift-support.patch
	eapply_user
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DBUILD_SHARED_LIBS=ON

		-DLLDB_DISABLE_CURSES=$(usex !ncurses)
		-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
		-DLLDB_DISABLE_PYTHON=$(usex !python)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)

		# normally we'd have to set LLVM_ENABLE_TERMINFO, HAVE_TERMINFO
		# and TERMINFO_LIBS... so just force FindCurses.cmake to use
		# ncurses with complete library set (including autodetection
		# of -ltinfo)
		-DCURSES_NEED_NCURSES=ON

		# LLVM options
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_CXX1Y=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON

		# swift
                -DSWIFTC=/usr/bin/swiftc
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make check-lldb-lit
	use python && cmake-utils_src_make check-lldb
}

src_install() {
	cmake-utils_src_install

	# oh my...
	if use python; then
		# remove bundled six module
		rm "${D}$(python_get_sitedir)/six.py" || die

		# remove custom readline.so for now
		# TODO: figure out how to deal with it
		# upstream is basically building a custom readline.so with -ledit
		# to avoid symbol collisions between readline and libedit...
		rm "${D}$(python_get_sitedir)/readline.so" || die

		# byte-compile the modules
		python_optimize
	fi
}
