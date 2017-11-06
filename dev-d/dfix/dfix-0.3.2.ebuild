# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dfmt is a formatter for D source code"
HOMEPAGE="https://github.com/Hackerpilot/dfmt"
LIBDPARSE="ca51bd13cf68646eaf9d6987db100cc3b288cffe"
SRC_URI="
	https://github.com/dlang-community/dfix/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dlang-community/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare() {
	# Default ebuild unpack function places archives side-by-side ...
	mv -T "../libdparse-${LIBDPARSE}" libdparse || die
	sed -i -e "/experimental_allocator/d" makefile || die
        sed -i -e "s|-g|-O5|g" makefile || die
	eapply_user
}

src_compile() {
	DMD=ldc2 emake
}

src_install() {
	dobin bin/dfix
	dodoc README.md
}
