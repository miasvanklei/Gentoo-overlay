# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to Easily bootstrap a secure Kubernetes cluster"
HOMEPAGE="https://kubernetes.io"
#MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4)).$(ver_cut 5)"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="hardened selinux"

BDEPEND=">=dev-lang/go-1.20"
RDEPEND="app-containers/cri-tools
	selinux? ( sec-policy/selinux-kubernetes )"

RESTRICT+=" test"
S="${WORKDIR}/kubernetes-${PV}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" FORCE_HOST_GO=yes \
		emake GOTOOLCHAIN="local" FORCE_HOST_GO="y" GOFLAGS=-v GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}
