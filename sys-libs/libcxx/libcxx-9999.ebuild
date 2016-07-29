# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/llvm-mirror/libcxx.git"

inherit git-r3 flag-o-matic toolchain-funcs multilib multilib-minimal

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="+static-libs test"

RDEPEND="sys-libs/libunwind[${MULTILIB_USEDEP}]
         sys-libs/libcxxabi[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( sys-devel/clang )
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

src_prepare() {
	cp -f "${FILESDIR}/Makefile" lib/ || die
	use elibc_musl && epatch "${FILESDIR}/${P}-musl-support.patch"
	multilib_copy_sources
}

src_configure() {
	append-cppflags -DLIBCXX_BUILDING_LIBCXXABI "-I${EPREFIX}/usr/include/libc++abi/"
	export LIBS="-lc++abi -lc -lgcc_s"
	cp "${EPREFIX}/usr/include/libc++abi/"*.h "${S}/include"

	tc-export AR CC CXX

	append-ldflags "-Wl,-z,defs" # make sure we are not underlinked
}

multilib_src_compile() {
	cd "${BUILD_DIR}/lib" || die
	emake shared
	use static-libs && emake static
}

# Tests fail for now, if anybody is able to fix them, help is very welcome.
multilib_src_test() {
	cd "${BUILD_DIR}/test"
	LD_LIBRARY_PATH="${BUILD_DIR}/lib:${LD_LIBRARY_PATH}" \
	CC="clang++ $(get_abi_CFLAGS) ${CXXFLAGS}" \
	HEADER_INCLUDE="-I${BUILD_DIR}/include" \
	SOURCE_LIB="-L${BUILD_DIR}/lib" \
	LIBS="-lm $(usex libcxxrt -lcxxrt "")" \
	./testit || die
	# TODO: fix link against libsupc++
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
	# Move it first.
	mv "${ED}/usr/$(get_libdir)/libc++.a" "${ED}/usr/$(get_libdir)/libc++_static.a" || die

	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps="${EPREFIX}/usr/$(get_libdir)/libc++_static.a ${EPREFIX}/usr/$(get_libdir)/libc++abi.a"
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps="${deps} ${EPREFIX}/usr/$(get_libdir)/libpthread.a ${EPREFIX}/usr/$(get_libdir)/libdl.a"

	# unlike libgcc_s, libunwind is not implicitly linked
	deps="${deps} ${EPREFIX}/usr/$(get_libdir)/libunwind.a"

	gen_ldscript "${deps}" > "${ED}/usr/$(get_libdir)/libc++.a"
	# TODO: Generate a libc++.a ldscript when building against libsupc++
}

gen_shared_ldscript() {
	mv "${ED}/usr/$(get_libdir)/libc++.so" "${ED}/usr/$(get_libdir)/libc++_shared.so" || die
	local deps="${EPREFIX}/usr/$(get_libdir)/libc++_shared.so ${EPREFIX}/usr/$(get_libdir)/libc++abi.so"
	deps="${deps} ${EPREFIX}/usr/$(get_libdir)/libunwind.so"
	gen_ldscript "${deps}" > "${ED}/usr/$(get_libdir)/libc++.so"
	# TODO: Generate the linker script for other configurations too.
}

multilib_src_install() {
	cd "${BUILD_DIR}/lib"
	if use static-libs ; then
		dolib.a libc++.a
		#gen_static_ldscript
	fi
	dolib.so libc++.so*
	#gen_shared_ldscript
}

multilib_src_install_all() {
	einstalldocs
	insinto /usr/include/c++/v1
	doins -r include/*
}
