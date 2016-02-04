# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libunwind/libunwind-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit cmake-utils flag-o-matic toolchain-funcs multilib-minimal git-r3

EGIT_REPO_URI="http://llvm.org/git/libunwind.git"

DESCRIPTION="unwind library"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND="sys-devel/llvm[clang]"

src_prepare() {
	epatch "${FILESDIR}"/unwind-fix-missing-condition-encoding.patch
	epatch "${FILESDIR}"/remove-llvm-src.patch
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_SHARED=OFF
		-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install

	mv ${D}/usr/$(get_libdir)/libunwind.a ${D}/usr/$(get_libdir)/libgcc_eh.a || die

	local compiler_rt_dir=$(${CC} -print-file-name= 2>/dev/null)
	local target=$(${CC} -dumpmachine)
	local arch

	case ${target} in
        	x86_64*) arch="x86_64";;
                arm*)   arch="armhf";; # We only have hardfloat right now
                ppc*)   arch="powerpc";;
                i?86*)   arch="i386";;
        esac

	cp ${compiler_rt_dir}/lib/linux/libclang_rt.builtins-${arch}.a ${D}/usr/$(get_libdir)/libgcc.a || die

	${CC} -shared -nodefaultlibs -lc -Wl,-soname,libgcc_s.so.1 -o ${D}/usr/$(get_libdir)/libgcc_s.so.1 \
	-Wl,--whole-archive ${D}/usr/$(get_libdir)/libgcc.a ${D}/usr/$(get_libdir)/libgcc_eh.a /usr/$(get_libdir)/libBlocksRuntime.a \
	-Wl,--no-whole-archive || die
	cd ${D}/usr/$(get_libdir) || die
	ln -s libgcc_s.so.1 libgcc_s.so || die
}

multilib_src_install_all() {
        mkdir "${D}"/usr/include
        cp -r "${S}"/include/* "${D}"/usr/include || die
}
