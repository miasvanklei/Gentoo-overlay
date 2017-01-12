# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.7.0-r1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_5 )

inherit cmake-utils flag-o-matic git-r3 \
	pax-utils python-any-r1 toolchain-funcs

DESCRIPTION="LLD linker"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/lld.git
        https://github.com/llvm-mirror/lld.git"

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug"

# python is needed for llvm-lit (which is installed)
RDEPEND="sys-libs/zlib:0=
	~sys-devel/llvm-${PV}:="
DEPEND="${RDEPEND}
	dev-lang/perl
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# Python is needed to run tests using lit
	python_setup

	# strip in lld, including comment section
	eapply "${FILESDIR}"/0001-strip-lld.patch

	# compat with gnu gold
	eapply "${FILESDIR}"/0002-gnu-ld-compat.patch
	eapply "${FILESDIR}"/0003-ignore-option.patch

	# add -z muldefs
	eapply "${FILESDIR}"/0004-add-muldefs-option.patch

	# remove broken commits
	eapply "${FILESDIR}"/0005-revert-add-retain-symbols-file.patch
	eapply "${FILESDIR}"/0006-does-not-work.patch

	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON
	)

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/llvm-tblgen" ]] \
			|| die "/usr/bin/llvm-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN=/usr/bin/llvm-tblgen
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check
}
