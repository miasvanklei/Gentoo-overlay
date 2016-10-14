# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.6.1-r1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic \
	multilib-minimal pax-utils python-any-r1 toolchain-funcs

DESCRIPTION="LLD linker"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/lld-${PV}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug"

# python is needed for llvm-lit (which is installed)
RDEPEND="sys-libs/zlib:0="
DEPEND="${RDEPEND}
	dev-lang/perl
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${P/_}.src

pkg_pretend() {
	# in megs
	# !debug !multitarget -O2       400
	# !debug  multitarget -O2       550
	#  debug  multitarget -O2      5G

	local build_size=550

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

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_setup() {
	pkg_pretend
}


src_prepare() {
	# Python is needed to run tests using lit
	python_setup

	eapply "${FILESDIR}"/0001-lld-standalone.patch
	eapply "${FILESDIR}"/0002-lld-disable-version-script-except-sandbox.patch
	eapply "${FILESDIR}"/0003-lld-gnu-ld-compat.patch
	eapply "${FILESDIR}"/0004-lld-ignore-options.patch
	eapply "${FILESDIR}"/0005-lld-add-nostdlib.patch

	# bugs found by compiling ghc
	eapply "${FILESDIR}"/0006-lld-do-not-merge-sections-in-case-of-relocatable-object-generation.patch
	eapply "${FILESDIR}"/0007-lld-do-not-ignore-relocations-addends.patch

	# bugs found by compiling rust
	eapply "${FILESDIR}"/0008-lld-accept-sh_entsize0.patch
	eapply "${FILESDIR}"/0009-lld-fix-dt_needed-value.patch

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
		-DLLVM_ENABLE_LLD=ON
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

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check
}

src_install() {
	multilib-minimal_src_install
}

multilib_src_install() {
	cmake-utils_src_install
}
