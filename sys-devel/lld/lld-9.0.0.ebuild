# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit cmake-utils llvm multiprocessing python-any-r1

MY_P=${P/_/}.src
LLVM_P=llvm-${PV/_/}.src

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz
	test? ( https://releases.llvm.org/${PV/_//}/${LLVM_P}.tar.xz )"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

S="${WORKDIR}/${MY_P}"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	einfo "Unpacking ${MY_P}.tar.xz ..."
	tar -xf "${DISTDIR}/${MY_P}.tar.xz" || die

	if use test; then
		einfo "Unpacking parts of ${LLVM_P}.tar.xz ..."
		tar -xf "${DISTDIR}/${LLVM_P}.tar.xz" \
			"${LLVM_P}"/utils/{lit,unittest} || die
		mv "${LLVM_P}" llvm || die
	fi
}
src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_DYLIB_COMPONENTS="all"

		-DLLVM_INCLUDE_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"
	)

	cmake-utils_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-lld
}

src_install() {
	cmake-utils_src_install

	# binutils symlinks
	dosym "lld" "/usr/bin/${CHOST}-lld"
	dosym "lld" "/usr/bin/${CHOST}-ld.lld"
	dosym "lld" "/usr/bin/${CHOST}-ld"
	dosym "lld" "/usr/bin/ld"
}