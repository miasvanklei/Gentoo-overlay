# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Compiler runtime libraries for clang"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/compiler-rt-${PV/_}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS=""
IUSE="-sanitize"

RDEPEND="
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-${PV}
	sanitize? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_unpack() {
        default

        mv "${WORKDIR}"/${P/_}.src "${S}" \
                || die "compiler-rt source directory move failed"
}

src_prepare() {
	eapply "${FILESDIR}"/compiler-rt-0001-add-blocks-support.patch
	eapply "${FILESDIR}"/compiler-rt-0002-add-shared.patch

	eapply_user
}

src_configure() {
	local clang_version=3.9.0
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${clang_version}"

		# TODO: tests do not support standalone builds
		-DCOMPILER_RT_INCLUDE_TESTS=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=$(usex sanitize)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use sanitize && python_doscript "${S}"/lib/asan/scripts/asan_symbolize.py
}
