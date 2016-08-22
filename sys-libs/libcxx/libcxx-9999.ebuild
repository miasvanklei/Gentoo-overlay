# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-multilib toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"

EGIT_REPO_URI="https://github.com/llvm-mirror/libcxx.git"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+experimental -libcxxrt +libunwind +static-libs"

RDEPEND="libcxxrt? ( >=sys-libs/libcxxrt-0.0_p20130725[libunwind=,static-libs?,${MULTILIB_USEDEP}] )
	!libcxxrt? ( ~sys-libs/libcxxabi-${PV}[libunwind=,static-libs?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

DOCS=( CREDITS.TXT )

pkg_setup() {
	if tc-is-gcc && [[ $(gcc-version) < 4.7 ]] ; then
		eerror "${PN} needs to be built with gcc-4.7 or later (or other"
		eerror "conformant compilers). Please use gcc-config to switch to"
		eerror "gcc-4.7 or later version."
		die
	fi
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local cxxabi=$(usex libcxxrt libcxxrt libcxxabi)

	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${EPREFIX}/usr/include/${cxxabi}"
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=$(usex !libunwind)
		-DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON
		-DLIBCXX_HAS_MUSL_LIBC=ON
	)
	cmake-utils_src_configure
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

gen_static_ldscript() {
	local libdir=$(get_libdir)
	local cxxabi=$(usex libcxxrt libcxxrt libc++abi)

	# Move it first.
	mv "${ED}/usr/${libdir}/libc++.a" "${ED}/usr/${libdir}/libc++_static.a" || die

	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="${EPREFIX}/usr/${libdir}/libc++_static.a ${EPREFIX}/usr/${libdir}/${cxxabi}.a"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps="${deps} ${EPREFIX}/usr/${libdir}/libpthread.a ${EPREFIX}/usr/${libdir}/libdl.a"
	# unlike libgcc_s, libunwind is not implicitly linked
	use libunwind && deps="${deps} ${EPREFIX}/usr/${libdir}/libunwind.a"

	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.a"
}

gen_shared_ldscript() {
	local libdir=$(get_libdir)
	local cxxabi=$(usex libcxxrt libcxxrt libc++abi)

	mv "${ED}/usr/${libdir}/libc++.so" "${ED}/usr/${libdir}/libc++_shared.so" || die
	local deps="${EPREFIX}/usr/${libdir}/libc++_shared.so ${EPREFIX}/usr/${libdir}/${cxxabi}.so"
	use libunwind && deps="${deps} ${EPREFIX}/usr/${libdir}/libunwind.so"
	gen_ldscript "${deps}" > "${ED}/usr/${libdir}/libc++.so"
}

multilib_src_install() {
	cmake-utils_src_install
	gen_shared_ldscript
	use static-libs && gen_static_ldscript
}

multilib_src_install_all() {
	einstalldocs
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
