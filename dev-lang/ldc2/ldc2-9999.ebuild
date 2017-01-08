# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

inherit cmake-utils git-r3

SRC_URI=""
EGIT_REPO_URI="https://github.com/ldc-developers/ldc.git"

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/libconfig-1.4.7"
DEPEND=">=dev-util/cmake-2.8
	sys-devel/llvm
	${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/fix-libunwind-alignment.patch
	eapply ${FILESDIR}/fix-musl.patch
	eapply ${FILESDIR}/link-libunwind.patch
	eapply ${FILESDIR}/use-init-array.patch
	eapply ${FILESDIR}/nostrip-when-debug.patch
	eapply ${FILESDIR}/remove-backtrace.patch
	eapply ${FILESDIR}/remove-qsort_r.patch
	default
}

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_ENABLE_CXX1Y=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion
}
