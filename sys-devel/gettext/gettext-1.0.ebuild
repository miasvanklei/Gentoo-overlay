# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

inherit git-r3

SLOT="0"
KEYWORDS="~amd64 arm"
IUSE=""
SRC_URI=""
EGIT_REPO_URI="https://github.com/sabotage-linux/gettext-tiny"

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-build.patch
)

src_compile() {
	emake LIBINTL=MUSL prefix=/usr
}

src_install() {
	emake LIBINTL=MUSL DESTDIR=${D} prefix=/usr install
}
