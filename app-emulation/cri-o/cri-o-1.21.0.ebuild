# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT=bc1ef35a932acc2f6f3b6d3eb19a4f68aa9423f6

inherit go-module

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="https://github.com/cri-o/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="btrfs +device-mapper iptables +nftables selinux systemd"

COMMON_DEPEND="
	app-crypt/gpgme:=
	app-emulation/conmon
	app-emulation/runc
	dev-libs/glib:=
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	net-firewall/conntrack-tools
	net-misc/cni-plugins
	net-misc/socat
	sys-apps/iproute2
	sys-libs/libseccomp:=
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2:= )
	iptables? ( net-firewall/iptables )
	nftables? ( net-misc/cni-plugins-nftables )
	selinux? ( sys-libs/libselinux:= )
	systemd? ( sys-apps/systemd:= )"
DEPEND="
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!<app-emulation/podman-1.3.2-r1"

src_prepare() {
	eapply "${FILESDIR}"/fix-compile.patch

	default

	sed -e '/^GIT_.*/d' \
		-e '/	git diff --exit-code/d' \
		-e 's/$(GO) build -i/$(GO) build -v -work -x/' \
		-e 's/\${GIT_COMMIT}/'${EGIT_COMMIT}'/' \
		-e "s|^GIT_COMMIT := .*|GIT_COMMIT := ${EGIT_COMMIT}|" \
		-e "s|^COMMIT_NO := .*|COMMIT_NO := ${EGIT_COMMIT}|" \
		-i Makefile || die

	echo ".NOTPARALLEL: binaries docs" >> Makefile || die

	sed -e 's:/usr/local/bin:/usr/bin:' \
		-i contrib/systemd/* || die
}

src_compile() {
	[[ -f hack/btrfs_installed_tag.sh ]] || die
	use btrfs || { echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
		hack/btrfs_installed_tag.sh || die; }

	[[ -f hack/libdm_installed.sh ]] || die
	use device-mapper || { echo -e "#!/bin/sh\necho exclude_graphdriver_devicemapper" > \
		hack/libdm_installed.sh || die; }

	[[ -f hack/selinux_tag.sh ]] || die
	use selinux || { echo -e "#!/bin/sh\ntrue" > \
		hack/selinux_tag.sh || die; }

	mkdir -p bin || die
	GOBIN="${S}/bin" \
		emake all
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${D}${EPREFIX}/usr" install install.config install.systemd

	keepdir /etc/crio

	# crio.conf is empty
	rm "${ED}/etc/crio/crio.conf"
        cp $"${FILESDIR}/crio.conf.example" "${ED}/etc/crio/crio.conf.example" || die

	# Suppress crio log error messages triggered if these don't exist.
	keepdir /etc/containers/oci/hooks.d
	keepdir /usr/share/containers/oci/hooks.d

	# Suppress crio "Missing CNI default network" log message.
	keepdir /etc/cni/net.d
	insinto /etc/cni/net.d
	doins contrib/cni/99-loopback.conf
}
