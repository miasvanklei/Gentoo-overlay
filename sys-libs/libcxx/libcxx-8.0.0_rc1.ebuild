# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Ninja provides better scalability and cleaner verbose output, and is used
# throughout all LLVM projects.
: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python3_7 )

inherit cmake-multilib llvm multiprocessing python-any-r1 \
	toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"
SRC_URI="https://prereleases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm"

IUSE="+compiler-rt +libcxxabi libcxxrt +libunwind +static-libs test"
REQUIRED_USE="libunwind? ( || ( libcxxabi libcxxrt ) )
	?? ( libcxxabi libcxxrt )"
RESTRICT="!test? ( test )"

RDEPEND="
	compiler-rt? ( sys-libs/compiler-rt )
	libcxxabi? ( ~sys-libs/libcxxabi-${PV}[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	libcxxrt? ( sys-libs/libcxxrt[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxabi? ( !libcxxrt? ( >=sys-devel/gcc-4.7:=[cxx] ) )"
# llvm-6 for new lit options
# clang-3.9.0 installs necessary target symlinks unconditionally
# which removes the need for MULTILIB_USEDEP
DEPEND="${RDEPEND}
	test? ( >=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )
	app-arch/xz-utils
	>=sys-devel/llvm-6"

S=${WORKDIR}/${P/_/}.src

DOCS=( CREDITS.TXT )

PATCHES=(
	"${FILESDIR}"/0001-fix-atomic.patch
	"${FILESDIR}"/0002-fix-compiler-rt-multilib.patch
)

# least intrusive of all
CMAKE_BUILD_TYPE=Release

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup

	if ! use libcxxabi && ! use libcxxrt && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
	if tc-is-gcc && [[ $(gcc-version) < 4.7 ]] ; then
		eerror "${PN} needs to be built with gcc-4.7 or later (or other"
		eerror "conformant compilers). Please use gcc-config to switch to"
		eerror "gcc-4.7 or later version."
		die
	fi
}

multilib_src_configure() {
	local cxxabi cxxabi_incs
	if use libcxxabi; then
		cxxabi=libcxxabi
		cxxabi_incs="${EPREFIX}/usr/include/libcxxabi"
	elif use libcxxrt; then
		cxxabi=libcxxrt
		cxxabi_incs="${EPREFIX}/usr/include/libcxxrt"
	else
		local gcc_inc="${EPREFIX}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXX_USE_COMPILER_RT=$(usex compiler-rt)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_SUPPORTS_NODEFAULTLIBS_FLAG=OFF
	)

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		local jobs=${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}

		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv;-j;${jobs};--param=cxx_under_test=${clang_path}"
		)
	fi
	cmake-utils_src_configure
}

multilib_src_test() {
	cmake-utils_src_make check-libcxx
}

multilib_src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
