# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PV=${PV/_/-}

SRC_URI="https://github.com/ldc-developers/ldc/releases/download/v${MY_PV}/ldc-${MY_PV}-src.tar.gz"
DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~ppc ~ppc64"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=">=dev-util/cmake-2.8
	sys-devel/llvm:=
	${RDEPEND}"

S=${WORKDIR}/ldc-${MY_PV}-src

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=BOTH
		-DLDC_DYNAMIC_COMPILE=False
		-DD_FLAGS="${LDCFLAGS// /;}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion
}
