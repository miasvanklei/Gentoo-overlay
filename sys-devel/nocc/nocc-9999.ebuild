# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 systemd

EGO_SUM=(
	"github.com/coreos/go-systemd/v22 v22.5.0"
	"github.com/coreos/go-systemd/v22 v22.5.0/go.mod"
	"github.com/go-logr/logr v1.4.2"
	"github.com/go-logr/logr v1.4.2/go.mod"
	"github.com/go-logr/stdr v1.2.2"
	"github.com/go-logr/stdr v1.2.2/go.mod"
	"github.com/godbus/dbus/v5 v5.0.4/go.mod"
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
	"golang.org/x/net v0.37.0"
	"golang.org/x/net v0.37.0/go.mod"
	"golang.org/x/sys v0.31.0"
	"golang.org/x/sys v0.31.0/go.mod"
	"golang.org/x/text v0.23.0"
	"golang.org/x/text v0.23.0/go.mod"
	"google.golang.org/genproto/googleapis/rpc v0.0.0-20250324211829-b45e905df463"
	"google.golang.org/genproto/googleapis/rpc v0.0.0-20250324211829-b45e905df463/go.mod"
	"google.golang.org/grpc v1.71.0"
	"google.golang.org/grpc v1.71.0/go.mod"
	"google.golang.org/protobuf v1.36.6"
	"google.golang.org/protobuf v1.36.6/go.mod"
)

go-module_set_globals

DESCRIPTION="OCI-based implementation of Kubernetes Container Runtime Interface"
HOMEPAGE="https://cri-o.io/"
SRC_URI="${EGO_SUM_SRC_URI}"
EGIT_REPO_URI="https://github.com/miasvanklei/nocc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

BDEPEND=(
	dev-go/protobuf-go
	dev-go/protobuf-go-grpc
)

src_unpack() {
	git-r3_src_unpack

	go-module_setup_proxy
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${D}${EPREFIX}/usr"
}
