# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="CNI Plugins compatible with nftables"
HOMEPAGE="https://github.com/greenpau/cni-plugins"

SRC_URI="https://github.com/greenpau/cni-plugins/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="net-firewall/nftables"

RESTRICT+=" test"

S="${WORKDIR}/cni-plugins-${PV}"

src_unpack() {
	unpack ${FILESDIR}/cni-plugins-1.0.12-vendor.tar.xz
	default
}

src_compile() {
	# Do not pass LDFLAGS directly here, as the upstream Makefile adds some
	# data to it via +=
	emake \
		GOFLAGS="${GOFLAGS}" \
		GIT_SHA=${GIT_COMMIT} \
		GIT_COMMIT=${GIT_COMMIT:0:7} \
		GIT_TAG=v${MY_PV} \
		GIT_DIRTY=clean \
		build
}

src_install() {
	insinto /etc/cni/net.d
	doins assets/net.d/87-podman-bridge.conflist

	exeinto /opt/cni/bin
	newexe bin/cni-nftables-firewall.linux-amd64 cni-nftables-firewall
	newexe bin/cni-nftables-portmap.linux-amd64 cni-nftables-portmap
}
