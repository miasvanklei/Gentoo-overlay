# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.8.3"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Sparse matrices Rutherford/Boeing format tools"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/RBio"

LICENSE="GPL-2+"
SLOT="0/4"

KEYWORDS="~amd64 ~arm64"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DSUITESPARSE_DEMOS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}"

	# Run demo files
	./RBdemo < "${S}"/RBio/private/west0479.rua || die "failed testing"
}
