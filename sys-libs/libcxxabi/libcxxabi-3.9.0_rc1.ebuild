# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

DESCRIPTION="New implementation of low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI="http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/${P/_}.src.tar.xz
        http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/libcxx-${PV/_}.src.tar.xz"
S="${WORKDIR}/${P/_}.src"
LIBCXX_S="${WORKDIR}/libcxx-${PV/_}.src"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libunwind +static-libs"

DEPEND="libunwind? ( ~sys-libs/llvm-libunwind-${PV}[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# to support standalone build
	eapply "${FILESDIR}/${PN}-3.8-cmake.patch"

	# to support cxa_thread_atexit
	eapply "${FILESDIR}"/add-cxa_thread_atexit.patch

	if use elibc_musl; then
		pushd ${LIBCXX_S} >/dev/null || die
		eapply "${FILESDIR}/libcxx-3.8-musl-support.patch"
		popd >/dev/null || die
	fi
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_CONFIG=OFF
		-DLIBCXXABI_BUILT_STANDALONE=ON
		-DLIBCXXABI_USE_COMPILER_RT=ON
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_LIBCXX_INCLUDES="${LIBCXX_S}/include"
		-DLIBCXXABI_HAS_GCC_S_LIB=$(usex !libunwind)
		-DCMAKE_SHARED_LINKER_FLAGS=$(usex libunwind "-lunwind" "")
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	insinto "/usr/include/${PN}/"
	doins include/*
}
