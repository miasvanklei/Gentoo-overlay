# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit multilib-minimal git-r3 multilib-build flag-o-matic

EGIT_REPO_URI="https://github.com/mackyle/blocksruntime.git"

DESCRIPTION="c++ library from llvm"
HOMEPAGE="http://www.llvm.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"

RDEPEND="sys-devel/llvm[clang]"


src_prepare()
{
	epatch "${FILESDIR}"/fix-call-cc.patch
	multilib_copy_sources
}

multilib_src_configure() {
	append-flags "-fPIC"
	./buildlib
}

multilib_src_install() {
	env prefix=${D}/usr libdir=${D}/usr/$(get_libdir) ./installlib
}
