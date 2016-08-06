# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libunwind/libunwind-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=6

inherit cmake-utils flag-o-matic toolchain-funcs multilib-minimal git-r3

EGIT_REPO_URI="http://llvm.org/git/libunwind.git"

DESCRIPTION="unwind library"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND="sys-devel/llvm:0
sys-devel/llvm[clang]"

src_prepare() {
	eapply "${FILESDIR}"/unwind-fix-missing-condition-encoding.patch
	eapply "${FILESDIR}"/libunwind-3.8-cmake.patch
	eapply_user
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_CONFIG=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_BUILT_STANDALONE=ON
		-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=OFF
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install

#	local libdir=$(get_libdir)
#
#	mv ${D}/usr/${libdir}/libunwind.a ${D}/usr/${libdir}/libgcc_eh.a || die
#
#	local crtdir=$(${CC} -print-file-name= 2>/dev/null)
#
#	local arch=$(/${libdir}/ld-musl* 2>&1 | sed -n 's/^.*(\(.*\))$/\1/;1p')
#
#	cp ${crtdir}/lib/linux/libclang_rt.builtins-${arch}.a ${D}/usr/${libdir}/libgcc.a || die
#
#	einfo creating shared gcc library
#
#	${CC} -shared -nodefaultlibs -lc -Wl,-soname,libgcc_s.so.1 -o ${D}/usr/${libdir}/libgcc_s.so.1 \
#	-Wl,--whole-archive ${D}/usr/${libdir}/libgcc.a ${D}/usr/${libdir}/libgcc_eh.a \
#	-Wl,--no-whole-archive || die
#
#	cd ${D}/usr/${libdir} || die
#	ln -s libgcc_s.so.1 libgcc_s.so || die
#
#	einfo installing gcc library
#	local gccversion=$(${CC} -dumpversion) || die
#
#	mkdir -p ${D}/usr/lib/clang/${CHOST}/${gccversion}
#	mv ${D}/usr/${libdir}/libgcc* ${D}/usr/lib/clang/${CHOST}/${gccversion}
}

multilib_src_install_all() {

#	rm -r "${D}"/usr/lib64
#	rm -r "${D}"/usr/lib32
        mkdir "${D}"/usr/include
        cp -r "${S}"/include/* "${D}"/usr/include || die
}
