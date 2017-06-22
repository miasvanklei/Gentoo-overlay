# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils llvm python-single-r1 toolchain-funcs git-r3

DESCRIPTION="The LLVM debugger"
HOMEPAGE="http://llvm.org/"
SRC_URI="test? ( http://llvm.org/pre-releases/${PV/_//}/llvm-${PV/_/}.src.tar.xz )"
EGIT_REPO_URI="https://github.com/apple/swift-lldb.git"
EGIT_BRANCH="swift-4.0-branch"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+libedit ncurses +python +swift test"

RDEPEND="
	libedit? ( dev-libs/libedit:0= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	python? ( dev-python/six[${PYTHON_USEDEP}]
		${PYTHON_DEPS} )
	~sys-devel/clang-${PV}[xml]
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-4.0"
# swig-3.0.9+ generates invalid wrappers, #598708
# upstream: https://github.com/swig/swig/issues/769
DEPEND="${RDEPEND}
	python? ( || ( <dev-lang/swig-3.0.9
		  >dev-lang/swig-3.0.10 ) )
	test? ( ~dev-python/lit-${PV}[${PYTHON_USEDEP}] )
	dev-lang/swift
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

CMAKE_BUILD_TYPE=Release

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	if use test; then
		mv llvm-* llvm || die
	fi
}

src_prepare() {
	# fix musl/arm combination
	eapply "${FILESDIR}"/0001-musl-lldb-arm.patch

	# fix tests in stand-alone build
	eapply "${FILESDIR}"/0002-test-Fix-finding-LLDB-tools-when-building-stand-alon.patch

	# fix swig, broken in 3.0.9 and 3.0.10
	eapply "${FILESDIR}"/0003-fix-swig.patch

	# fix use with libedit-2017
	eapply "${FILESDIR}"/0004-fix-bug-28898.patch

	# fix apple/swift cmake mess
	eapply "${FILESDIR}"/0005-fix-cmake.patch
	eapply "${FILESDIR}"/0006-fix-includes.patch
	eapply "${FILESDIR}"/0007-fix-resourcedir.patch

	# fix compilation with llvm 4.0
	eapply "${FILESDIR}"/0008-llvm-4.0.patch

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DLLDB_DISABLE_CURSES=$(usex !ncurses)
		-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
		-DLLDB_DISABLE_PYTHON=$(usex !python)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)

		-DLLVM_BUILD_TESTS=$(usex test)
		# compilers for lit tests
		-DLLDB_TEST_C_COMPILER="$(type -P clang)"
		-DLLDB_TEST_CXX_COMPILER="$(type -P clang++)"
		# compiler for ole' python tests
		-DLLDB_TEST_COMPILER="$(type -P clang)"

		# TODO: fix upstream to detect this properly
		-DHAVE_LIBDL=ON
		-DHAVE_LIBPTHREAD=ON

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON

		# swift garbage
		-DLLDB_PATH_TO_SWIFT_BUILD=/usr
		-DLLDB_PATH_TO_CMARK_BUILD=/usr

		# normally we'd have to set LLVM_ENABLE_TERMINFO, HAVE_TERMINFO
		# and TERMINFO_LIBS... so just force FindCurses.cmake to use
		# ncurses with complete library set (including autodetection
		# of -ltinfo)
		-DCURSES_NEED_NCURSES=ON
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
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
