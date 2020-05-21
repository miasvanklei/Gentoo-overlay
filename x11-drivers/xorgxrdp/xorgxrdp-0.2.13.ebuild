# Copyright 2017 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Xorg drivers for xrdp"
HOMEPAGE="http://www.xrdp.org/"
SRC_URI="https://github.com/neutrinolabs/xorgxrdp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+glamor"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-misc/xrdp:0=
	glamor? ( x11-base/xorg-server[-minimal] )"
DEPEND="${RDEPEND}
	dev-lang/nasm:0="

PATCHES=(
	"${FILESDIR}"/add-glamoregl.patch
)

pkg_setup() {
        XORG_CONFIGURE_OPTIONS=(
                $(use_enable glamor)
        )
}
