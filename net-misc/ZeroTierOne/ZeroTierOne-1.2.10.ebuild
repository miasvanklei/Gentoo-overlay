# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="A Smart Ethernet Switch for Earth"
HOMEPAGE="https://github.com/zerotier/ZeroTierOne"
SRC_URI="https://github.com/zerotier/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="systemd"

src_prepare()
{
	eapply ${FILESDIR}/fix-makefile.patch
	eapply_user
}

src_compile() {
	emake
}

src_install() {
	default
	if use systemd; then
		systemd_dounit	"${S}"/debian/zerotier-one.service
	else
		newinitd "${FILESDIR}"/zerotier-one.rc zerotier-one
	fi
}
