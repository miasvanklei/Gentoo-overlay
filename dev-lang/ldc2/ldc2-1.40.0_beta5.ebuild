# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..19} )
inherit cmake llvm-r1

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~ppc ~ppc64"
LICENSE="BSD"
SLOT="$(ver_cut 1-2)/$(ver_cut 3)"

MY_PV="${PV/_/-}"
MY_PN="ldc-${MY_PV}"
SRC_URI="https://github.com/ldc-developers/ldc/releases/download/v${MY_PV}/${MY_PN}-src.tar.gz"

IUSE="debug"

BOOTSTRAP_DEPEND="||
        (
                =dev-lang/ldc2-$(ver_cut 1).$(($(ver_cut 2) - 1))*
                =dev-lang/ldc2-$(ver_cut 1).$(ver_cut 2)*
        )
"

BDEPEND="${PYTHON_DEPS}
        app-eselect/eselect-dlang
	${BOOTSTRAP_DEPEND}
"

DEPEND="
        ${PYTHON_DEPS}
        $(llvm_gen_dep '
                llvm-core/clang:${LLVM_SLOT}
        ')
	sys-libs/zlib
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-src"

pkg_setup() {
	llvm-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=BOTH
		-DLDC_DYNAMIC_COMPILE=False
		-DLDC_WITH_LLD=OFF
		-DPHOBOS_SYSTEM_ZLIB=ON
		-DD_FLAGS="${LDCFLAGS// /;}"
		-DCMAKE_INSTALL_PREFIX=/usr/lib/ldc2/$(ver_cut 1-2)
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
        use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake_src_configure
}

src_install() {
	cmake_src_install

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
