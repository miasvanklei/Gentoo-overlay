# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 systemd

DESCRIPTION="A distributed C++ compiler: like distcc, but faster"
HOMEPAGE="https://github.com/miasvanklei/nocc"
EGIT_REPO_URI="https://github.com/miasvanklei/nocc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

BDEPEND="
	dev-go/protobuf-go
	dev-go/protoc-gen-go-grpc
"

RDEPEND="
	dev-util/shadowman
	sys-apps/coreutils
	sys-apps/util-linux
"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${D}${EPREFIX}/usr"

	insinto /usr/share/shadowman/tools
	newins - nocc <<<"${EPREFIX}/usr/lib/nocc"
}

pkg_postinst() {
	if [[ -z ${ROOT} ]]; then
		eselect compiler-shadow update nocc
	fi
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && -z ${ROOT} ]]; then
		eselect compiler-shadow remove nocc
	fi
}
