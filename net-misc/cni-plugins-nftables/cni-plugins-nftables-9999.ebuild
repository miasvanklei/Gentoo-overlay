# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 go-module

DESCRIPTION="CNI Plugins compatible with nftables"
HOMEPAGE="https://github.com/greenpau/cni-plugins"

EGO_SUM=(
	"github.com/Microsoft/go-winio v0.4.11/go.mod"
	"github.com/Microsoft/hcsshim v0.8.6/go.mod"
	"github.com/alexflint/go-filemutex v0.0.0-20171022225611-72bdc8eae2ae/go.mod"
	"github.com/buger/jsonparser v0.0.0-20180808090653-f4dd9f5a6b44/go.mod"
	"github.com/containernetworking/cni v0.8.1"
	"github.com/containernetworking/cni v0.8.1/go.mod"
	"github.com/containernetworking/plugins v0.9.1"
	"github.com/containernetworking/plugins v0.9.1/go.mod"
	"github.com/coreos/go-iptables v0.5.0/go.mod"
	"github.com/coreos/go-systemd v0.0.0-20180511133405-39ca1b05acc7/go.mod"
	"github.com/d2g/dhcp4 v0.0.0-20170904100407-a1d1b6c41b1c/go.mod"
	"github.com/d2g/dhcp4client v1.0.0/go.mod"
	"github.com/d2g/dhcp4server v0.0.0-20181031114812-7d4a0a7f59a5/go.mod"
	"github.com/d2g/hardwareaddr v0.0.0-20190221164911-e7d9fbe030e4/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/godbus/dbus v0.0.0-20180201030542-885f9cc04c9c/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.1.0.20200221234624-67d41d38c208/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.2/go.mod"
	"github.com/golang/protobuf v1.4.0-rc.4.0.20200313231945-b860323f09d0/go.mod"
	"github.com/golang/protobuf v1.4.0/go.mod"
	"github.com/golang/protobuf v1.4.2"
	"github.com/golang/protobuf v1.4.2/go.mod"
	"github.com/google/go-cmp v0.2.0/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/go-cmp v0.3.1"
	"github.com/google/go-cmp v0.3.1/go.mod"
	"github.com/google/go-cmp v0.4.0"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/google/go-cmp v0.5.2/go.mod"
	"github.com/google/go-cmp v0.5.4"
	"github.com/google/go-cmp v0.5.4/go.mod"
	"github.com/google/nftables v0.0.0-20201230142148-715e31cb3c31"
	"github.com/google/nftables v0.0.0-20201230142148-715e31cb3c31/go.mod"
	"github.com/greenpau/versioned v1.0.24"
	"github.com/greenpau/versioned v1.0.24/go.mod"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/j-keck/arping v0.0.0-20160618110441-2cf9dc699c56/go.mod"
	"github.com/josharian/native v0.0.0-20200817173448-b6b71def0850"
	"github.com/josharian/native v0.0.0-20200817173448-b6b71def0850/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20190606172950-9527aa82566a"
	"github.com/jsimonetti/rtnetlink v0.0.0-20190606172950-9527aa82566a/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20200117123717-f846d4f6c1f4/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20201009170750-9c6f07d100c1/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20201216134343-bde56ed16391/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20201220180245-69540ac93943/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20210122163228-8d122574c736/go.mod"
	"github.com/jsimonetti/rtnetlink v0.0.0-20210212075122-66c871082f2b"
	"github.com/jsimonetti/rtnetlink v0.0.0-20210212075122-66c871082f2b/go.mod"
	"github.com/koneu/natend v0.0.0-20150829182554-ec0926ea948d"
	"github.com/koneu/natend v0.0.0-20150829182554-ec0926ea948d/go.mod"
	"github.com/mattn/go-shellwords v1.0.3/go.mod"
	"github.com/mdlayher/ethtool v0.0.0-20210210192532-2b88debcdd43"
	"github.com/mdlayher/ethtool v0.0.0-20210210192532-2b88debcdd43/go.mod"
	"github.com/mdlayher/genetlink v1.0.0"
	"github.com/mdlayher/genetlink v1.0.0/go.mod"
	"github.com/mdlayher/netlink v0.0.0-20190409211403-11939a169225/go.mod"
	"github.com/mdlayher/netlink v0.0.0-20191009155606-de872b0d824b"
	"github.com/mdlayher/netlink v0.0.0-20191009155606-de872b0d824b/go.mod"
	"github.com/mdlayher/netlink v1.0.0/go.mod"
	"github.com/mdlayher/netlink v1.1.0/go.mod"
	"github.com/mdlayher/netlink v1.1.1/go.mod"
	"github.com/mdlayher/netlink v1.2.0/go.mod"
	"github.com/mdlayher/netlink v1.2.1/go.mod"
	"github.com/mdlayher/netlink v1.2.2-0.20210123213345-5cc92139ae3e/go.mod"
	"github.com/mdlayher/netlink v1.3.0/go.mod"
	"github.com/mdlayher/netlink v1.4.0"
	"github.com/mdlayher/netlink v1.4.0/go.mod"
	"github.com/nxadm/tail v1.4.4"
	"github.com/nxadm/tail v1.4.4/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/ginkgo v1.12.1"
	"github.com/onsi/ginkgo v1.12.1/go.mod"
	"github.com/onsi/gomega v1.7.1/go.mod"
	"github.com/onsi/gomega v1.10.3"
	"github.com/onsi/gomega v1.10.3/go.mod"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/safchain/ethtool v0.0.0-20190326074333-42ed695e3de8/go.mod"
	"github.com/sirupsen/logrus v1.0.6/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/vishvananda/netlink v1.1.1-0.20201029203352-d40f9887b852"
	"github.com/vishvananda/netlink v1.1.1-0.20201029203352-d40f9887b852/go.mod"
	"github.com/vishvananda/netns v0.0.0-20180720170159-13995c7128cc"
	"github.com/vishvananda/netns v0.0.0-20180720170159-13995c7128cc/go.mod"
	"github.com/vishvananda/netns v0.0.0-20200728191858-db3c7e526aae"
	"github.com/vishvananda/netns v0.0.0-20200728191858-db3c7e526aae/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190827160401-ba9fcec4b297/go.mod"
	"golang.org/x/net v0.0.0-20191007182048-72f939374954/go.mod"
	"golang.org/x/net v0.0.0-20191028085509-fe3aa8a45271/go.mod"
	"golang.org/x/net v0.0.0-20200202094626-16171245cfb2/go.mod"
	"golang.org/x/net v0.0.0-20201006153459-a7d1128ccaa0"
	"golang.org/x/net v0.0.0-20201006153459-a7d1128ccaa0/go.mod"
	"golang.org/x/net v0.0.0-20201010224723-4f7140c49acb/go.mod"
	"golang.org/x/net v0.0.0-20201110031124-69a78807bb2b/go.mod"
	"golang.org/x/net v0.0.0-20201216054612-986b41b23924/go.mod"
	"golang.org/x/net v0.0.0-20201224014010-6772e930b67b/go.mod"
	"golang.org/x/net v0.0.0-20210119194325-5f4716e94777"
	"golang.org/x/net v0.0.0-20210119194325-5f4716e94777/go.mod"
	"golang.org/x/net v0.0.0-20210614182718-04defd469f4e"
	"golang.org/x/net v0.0.0-20210614182718-04defd469f4e/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190312061237-fead79001313/go.mod"
	"golang.org/x/sys v0.0.0-20190411185658-b44545bcd369/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456/go.mod"
	"golang.org/x/sys v0.0.0-20190904154756-749cb33beabd/go.mod"
	"golang.org/x/sys v0.0.0-20191008105621-543471e840be/go.mod"
	"golang.org/x/sys v0.0.0-20191029155521-f43be2a4598c/go.mod"
	"golang.org/x/sys v0.0.0-20191120155948-bd437916bb0e/go.mod"
	"golang.org/x/sys v0.0.0-20200202164722-d101bd2416d5/go.mod"
	"golang.org/x/sys v0.0.0-20200217220822-9197077df867/go.mod"
	"golang.org/x/sys v0.0.0-20200728102440-3e129f6d46b1/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/sys v0.0.0-20201009025420-dfb3f7c4e634/go.mod"
	"golang.org/x/sys v0.0.0-20201117170446-d9b008d0a637"
	"golang.org/x/sys v0.0.0-20201117170446-d9b008d0a637/go.mod"
	"golang.org/x/sys v0.0.0-20201118182958-a01c418693c7/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20201218084310-7d0127a74742/go.mod"
	"golang.org/x/sys v0.0.0-20210110051926-789bb1bd4061/go.mod"
	"golang.org/x/sys v0.0.0-20210123111255-9b0068b26619/go.mod"
	"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c/go.mod"
	"golang.org/x/sys v0.0.0-20210216163648-f7da38b97c65"
	"golang.org/x/sys v0.0.0-20210216163648-f7da38b97c65/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210616094352-59db8d763f22"
	"golang.org/x/sys v0.0.0-20210616094352-59db8d763f22/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.6"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"google.golang.org/protobuf v0.0.0-20200109180630-ec00e32a8dfd/go.mod"
	"google.golang.org/protobuf v0.0.0-20200221191635-4d8936d0db64/go.mod"
	"google.golang.org/protobuf v0.0.0-20200228230310-ab0ca4ff8a60/go.mod"
	"google.golang.org/protobuf v1.20.1-0.20200309200217-e05f789c0967/go.mod"
	"google.golang.org/protobuf v1.21.0/go.mod"
	"google.golang.org/protobuf v1.23.0"
	"google.golang.org/protobuf v1.23.0/go.mod"
	"gopkg.in/airbrake/gobrake.v2 v2.0.9/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/gemnasium/logrus-airbrake-hook.v2 v2.1.2/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"gopkg.in/yaml.v2 v2.3.0"
	"gopkg.in/yaml.v2 v2.3.0/go.mod"
	)
go-module_set_globals
SRC_URI="${EGO_SUM_SRC_URI}"
EGIT_REPO_URI="https://github.com/greenpau/cni-plugins.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="net-firewall/nftables"

RESTRICT+=" test"

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	go-module_src_unpack
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
