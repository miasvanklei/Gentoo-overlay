# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# tarball generated using "gh workflow -R ${repo}/gentoo-deps run generator.yml -f REPO=grpc/grpc-go -f TAG=v${PV} -f P=protobuf-go-grpc-${PV} -f LANG=golang -f WORKDIR=cmd/protoc-gen-go-grpc"

DESCRIPTION="A tool to generate Go language bindings of services in protobuf definition files for gRPC."
HOMEPAGE="https://github.com/grpc/grpc-go/tree/master/cmd/protoc-gen-go-grpc"
SRC_URI="
	https://github.com/grpc/grpc-go/archive/refs/tags/v${PV}.tar.gz -> grpc-go-${PV}.tar.gz
	https://github.com/miasvanklei/gentoo-deps/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="dev-libs/protobuf"

S="${WORKDIR}/grpc-go-${PV}/cmd/protoc-gen-go-grpc"

src_compile() {
	ego build
}

src_install() {
	dobin protoc-gen-go-grpc
}
