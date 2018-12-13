# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3 systemd toolchain-funcs

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI=""
EGIT_REPO_URI="https://github.com/zerotier/ZeroTierOne.git"
EGIT_BRANCH="dev"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-libs/json-glib:=
	net-libs/http-parser:=
	net-libs/libnatpmp:=
	net-libs/miniupnpc:="

DEPEND="${RDEPEND}"

DOCS=( README.md AUTHORS.md )

PATCHES=(
	"${FILESDIR}"/add-armv7.patch
	"${FILESDIR}"/missing-include.patch
)

src_compile() {
#	append-ldflags -Wl,-z,noexecstack
	emake CXX="$(tc-getCXX)" AS="$(tc-getCXX)" ASFLAGS="-c" STRIP=: one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default

	systemd_dounit "${FILESDIR}/${PN}".service
}
