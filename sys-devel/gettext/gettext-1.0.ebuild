# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="stub and/or lightweight replacements of the gnu gettext suite; because the GNU one takes ages to compile"
HOMEPAGE="https://github.com/sabotage-linux/gettext-tiny"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sabotage-linux/gettext-tiny"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64"
IUSE=""

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-cflags.patch
)

src_compile() {
	emake LIBINTL=MUSL prefix=/usr
}

src_install() {
	emake LIBINTL=MUSL DESTDIR=${D} prefix=/usr install
}
