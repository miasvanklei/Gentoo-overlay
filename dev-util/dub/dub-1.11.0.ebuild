# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Package and build management system for the D programming language"
HOMEPAGE="http://code.dlang.org/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="debug"

SRC_URI="https://github.com/dlang/dub/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-output.patch
)

src_compile() {
	./build.sh || die
}

src_install() {
	dobin bin/dub
	dodoc README.md
}
