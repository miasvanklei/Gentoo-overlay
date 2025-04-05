# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
"github.com/go-logr/logr v1.2.2"
"github.com/go-logr/logr v1.2.2/go.mod"
"github.com/go-logr/logr v1.4.2"
"github.com/go-logr/logr v1.4.2/go.mod"
"github.com/go-logr/stdr v1.2.2"
"github.com/go-logr/stdr v1.2.2/go.mod"
"github.com/golang/protobuf v1.5.4"
"github.com/golang/protobuf v1.5.4/go.mod"
"github.com/google/go-cmp v0.6.0"
"github.com/google/go-cmp v0.6.0/go.mod"
"github.com/google/uuid v1.6.0"
"github.com/google/uuid v1.6.0/go.mod"
"go.opentelemetry.io/auto/sdk v1.1.0"
"go.opentelemetry.io/auto/sdk v1.1.0/go.mod"
"go.opentelemetry.io/otel v1.34.0"
"go.opentelemetry.io/otel v1.34.0/go.mod"
"go.opentelemetry.io/otel/metric v1.34.0"
"go.opentelemetry.io/otel/metric v1.34.0/go.mod"
"go.opentelemetry.io/otel/sdk v1.34.0"
"go.opentelemetry.io/otel/sdk v1.34.0/go.mod"
"go.opentelemetry.io/otel/sdk/metric v1.34.0"
"go.opentelemetry.io/otel/sdk/metric v1.34.0/go.mod"
"go.opentelemetry.io/otel/trace v1.34.0"
"go.opentelemetry.io/otel/trace v1.34.0/go.mod"
"golang.org/x/net v0.34.0"
"golang.org/x/net v0.34.0/go.mod"
"golang.org/x/sys v0.29.0"
"golang.org/x/sys v0.29.0/go.mod"
"golang.org/x/text v0.21.0"
"golang.org/x/text v0.21.0/go.mod"
"google.golang.org/genproto/googleapis/rpc v0.0.0-20250115164207-1a7da9e5054f"
"google.golang.org/genproto/googleapis/rpc v0.0.0-20250115164207-1a7da9e5054f/go.mod"
"google.golang.org/grpc v1.70.0"
"google.golang.org/grpc v1.70.0/go.mod"
"google.golang.org/protobuf v1.36.4"
"google.golang.org/protobuf v1.36.4/go.mod"
)

go-module_set_globals

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="
	https://github.com/grpc/grpc-go/archive/refs/tags/v1.71.0.tar.gz -> grpc-go-${PV}.tar.gz
	${EGO_SUM_SRC_URI}
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
