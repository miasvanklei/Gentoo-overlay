# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

inherit cmake-utils

SRC_URI="https://github.com/ldc-developers/ldc/releases/download/v${PV}/ldc-${PV}-src.tar.gz"
DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=">=dev-util/cmake-2.8
	sys-devel/llvm:=
	${RDEPEND}"

S=${WORKDIR}/ldc-${PV}-src

PATCHES=(
	"${FILESDIR}"/link-libunwind.patch
	"${FILESDIR}"/wrong-type.patch
)

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=BOTH
		-DD_FLAGS="${LDCFLAGS// /;}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion
}
