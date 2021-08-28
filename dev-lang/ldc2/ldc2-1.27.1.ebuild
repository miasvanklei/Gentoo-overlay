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
SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
IUSE=""

BOOTSTRAP_DEPEND="||
        (
                =dev-lang/ldc2-$(ver_cut 1).$(($(ver_cut 2) - 1))*
                =dev-lang/ldc2-$(ver_cut 1).$(ver_cut 2)*
        )
"

BDEPEND="${PYTHON_DEPS}
        app-eselect/eselect-dlang
        || (
                >=sys-devel/gcc-4.7
                >=sys-devel/clang-3.5
        )
	${BOOTSTRAP_DEPEND}
"

RDEPEND=""
DEPEND=">=dev-util/cmake-2.8
	sys-devel/llvm:=
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/llvm-13.patch
)

S=${WORKDIR}/ldc-${MY_PV}-src

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=BOTH
		-DLDC_DYNAMIC_COMPILE=False
		-DD_FLAGS="${LDCFLAGS// /;}"
		-DCMAKE_INSTALL_PREFIX=/usr/lib/ldc2/$(ver_cut 1-2)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion

        local revord=$(( 9999 - $(ver_cut 2) ))
        newenvd - "60ldc2-${revord}" <<-_EOF_
		LDPATH="/usr/lib/ldc2/$(ver_cut 1-2)/lib"
	_EOF_

}

pkg_postinst() {
	eselect dlang update
}

pkg_postrm() {
	eselect dlang update
}
