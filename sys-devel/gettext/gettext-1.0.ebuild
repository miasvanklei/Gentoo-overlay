# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

inherit git-r3

SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
SRC_URI=""
EGIT_REPO_URI="https://github.com/sabotage-linux/gettext-tiny"

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-cflags.patch
	"${FILESDIR}"/fix-install.patch
	"${FILESDIR}"/remove-garbage.patch
)

src_compile() {
	emake LIBINTL=MUSL prefix=/usr
}

src_install() {
	emake LIBINTL=MUSL DESTDIR=${D} prefix=/usr install
	mv ${D}/usr/share/gettext/m4 ${D}/usr/share/aclocal || die
}
