# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson udev

DESCRIPTION="Server for FastRPC remote procedure calls from Qualcomm DSPs"
HOMEPAGE="https://github.com/linux-msm/hexagonrpc"
EGIT_REPO_URI="https://github.com/linux-msm/hexagonrpc.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="acct-user/fastrpc"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/support-more-methods.patch
)

src_install() {
	meson_install

	udev_dorules ${FILESDIR}/71-fastrpc.rules
}

pkg_postinst() {
        udev_reload
}

pkg_postrm() {
        udev_reload
}
