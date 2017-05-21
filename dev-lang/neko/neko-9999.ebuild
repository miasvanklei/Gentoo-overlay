# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Neko is a high-level dynamically typed programming language."
HOMEPAGE="http://nekovm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/HaxeFoundation/neko.git"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE=""

DEPEND="dev-libs/boehm-gc[threads]"
RDEPEND="${DEPEND}"

src_configure() {
        local mycmakeargs=(
                -DWITH_APACHE=OFF
		-DWITH_MYSQL=OFF
		-DWITH_SSL=OFF
		-DRUN_LDCONFIG=OFF
        )

        cmake-utils_src_configure
}
