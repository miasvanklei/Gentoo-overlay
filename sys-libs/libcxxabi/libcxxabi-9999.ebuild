# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="New implementation of low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
EGIT_REPO_URI="https://github.com/llvm-mirror/libcxxabi.git"

LIBCXX_S="${WORKDIR}/libcxx"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libunwind +static-libs"

DEPEND="libunwind? ( ~sys-libs/llvm-libunwind-${PV}[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	git-r3_fetch "https://github.com/llvm-mirror/libcxx.git"

	git-r3_checkout https://github.com/llvm-mirror/libcxx.git "${LIBCXX_S}"

	# to support standalone build
	eapply "${FILESDIR}/${PN}-3.8-cmake.patch"

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
