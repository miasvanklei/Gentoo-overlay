# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils llvm multiprocessing python-any-r1

MY_P=${P/_/}.src
LLVM_P=llvm-${PV/_/}.src

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz
	test? ( http://releases.llvm.org/${PV/_//}/${LLVM_P}.tar.xz )"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

S=${WORKDIR}/${MY_P}

# least intrusive of all
CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/no-crash-r-use-linker-script-with-discard.patch
	"${FILESDIR}"/fix-alignment-power-2.patch
)

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
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
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_DYLIB_COMPONENTS="all"

		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_CXX1Y=ON
		-DLLVM_ENABLE_LLD=ON

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
