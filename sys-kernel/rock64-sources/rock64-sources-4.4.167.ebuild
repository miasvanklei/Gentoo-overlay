# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
BUILD_URI="1140"
ROCK64_URI="https://github.com/ayufan-rock64/linux-kernel/archive/"

inherit kernel-2
detect_version
detect_arch

KVER="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
KEYWORDS="~arm64"
HOMEPAGE="https://github.com/ayufan-rock64/linux-kernel"
IUSE=""

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${ROCK64_URI}${KVER}-${BUILD_URI}-rockchip-ayufan.tar.gz ${ARCH_URI}"

S=${WORKDIR}/linux-kernel-${KVER}-${BUILD_URI}-rockchip-ayufan

src_unpack() {
	default
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
