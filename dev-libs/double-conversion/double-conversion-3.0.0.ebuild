# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="amd64 arm ~arm64 hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

CMAKE_BUILD_TYPE=Release

src_configure() {
        local mycmakeargs=(
                -DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
        )

        cmake-utils_src_configure
}

src_test() {
	export LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH}"
	test/cctest/cctest --list | tr -d '<' | xargs test/cctest/cctest || die
}

src_install() {
        cmake-utils_src_configure
	dodoc README Changelog AUTHORS
}
