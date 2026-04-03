# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="Qualcomm FastRPC userspace library for CPU↔DSP remote procedure calls"
HOMEPAGE="https://github.com/qualcomm/fastrpc"
SRC_URI="https://github.com/qualcomm/fastrpc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	acct-user/fastrpc
	dev-libs/libyaml
	dev-libs/libbsd
"

DEPEND="
    ${RDEPEND}
"

BDEPEND="
    virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/0001-fix-startup-race-condition-with-udev-rules.patch"
	"${FILESDIR}/0002-add-sensorspd-adsp.patch"
)

src_prepare() {
	default

	sed -i -e 's/test//' Makefile.am || die

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
        udev_reload
}

pkg_postrm() {
        udev_reload
}
