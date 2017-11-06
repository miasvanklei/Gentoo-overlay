# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A Smart Ethernet Switch for Earth"
HOMEPAGE="https://github.com/zerotier/ZeroTierOne"
EGIT_REPO_URI="https://github.com/zerotier/ZeroTierOne"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

src_compile() {
	emake
}

src_install() {
	default
	newinitd "${FILESDIR}"/zerotier-one.rc zerotier-one
}
