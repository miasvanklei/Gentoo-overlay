# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV=${PV/_/-}

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~ppc ~ppc64"
LICENSE="BSD"
SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
SRC_URI="https://github.com/ldc-developers/ldc/releases/download/v${PV}/ldc-${PV}-src.tar.gz"

IUSE="debug"

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

DEPEND="sys-devel/llvm:=[debug?]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/musl-lfs64.patch
	"${FILESDIR}"/missing-version_net.patch
)

S="${WORKDIR}/ldc-${PV}-src"

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DBUILD_SHARED_LIBS=BOTH
		-DLDC_DYNAMIC_COMPILE=False
		-DLDC_WITH_LLD=OFF
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
