# Copyright 1999-2018 Gentoo Authors
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
EGIT_BRANCH="newpoparser"

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-cflags.patch
)

src_prepare() {
	cp "${FILESDIR}"/pthread_rwlock_rdlock.m4 "${S}"/m4/ || die
	default
}

src_compile() {
	emake LIBINTL=MUSL prefix=/usr
}

src_install() {
	emake LIBINTL=MUSL DESTDIR=${D} prefix=/usr install
}
