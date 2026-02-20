# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED="fortran"
inherit cmake fortran-2 toolchain-funcs

MY_PN="SuiteSparse"

DESCRIPTION="The official SuiteSparse library: a suite of sparse matrix algorithms authored or co-authored by Tim Davis, Texas A&M University"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${PV}.tar.gz -> ${MY_PN}-${PV}.gh.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0/7"

KEYWORDS="~amd64 ~arm64"
IUSE="cuda fortran openmp +supernodal test"
RESTRICT="!test? ( test )"

# we need to depend on blas as the cmake file looks for it.
# It is also a runtime dependency as it has headers to link with blas
DEPEND="sci-libs/flexiblas"
RDEPEND="
	${DEPEND}
	supernodal? ( virtual/lapack )
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)
"

PATCHES=(
	"${FILESDIR}"/incompatible-pointer-types.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=OFF
		-DCHOLMOD_USE_CUDA=$(usex cuda)
		-DCHOLMOD_USE_OPENMP=$(usex openmp)
		-DCHOLMOD_SUPERNODAL=$(usex supernodal)
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_HAS_FORTRAN=$(usex fortran)
		-DSUITESPARSE_USE_OPENMP=$(usex openmp ON OFF)
		-DSUITESPARSE_USE_64BIT_BLAS=ON
	)
	cmake_src_configure
}
