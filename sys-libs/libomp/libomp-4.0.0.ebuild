# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-multilib

MY_PV=openmp-${PV/_/}.src
DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="http://openmp.llvm.org"
SRC_URI="http://releases.llvm.org/${PV/_//}/${MY_PV}.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hwloc +ompt"

RDEPEND="hwloc? ( sys-apps/hwloc:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-lang/perl"

S=${WORKDIR}/${MY_PV}

src_prepare() {
	eapply "${FILESDIR}"/${P}-use-va_copy-macro.patch
	default
}

multilib_src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIBOMP_LIBDIR_SUFFIX="${libdir#lib}"
		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)
		-DLIBOMP_COPY_EXPORTS=OFF
	)

	cmake-utils_src_configure
}
