# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_PN="github.com/go-delve/delve/cmd/dlv"

EGO_SUM=(
"github.com/chzyer/logex v1.1.10/go.mod"
"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e"
"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
"github.com/cosiner/argv v0.0.0-20170225145430-13bacc38a0a5"
"github.com/cosiner/argv v0.0.0-20170225145430-13bacc38a0a5/go.mod"
"github.com/cosiner/argv v0.1.0"
"github.com/cosiner/argv v0.1.0/go.mod"
"github.com/cpuguy83/go-md2man v1.0.10"
"github.com/cpuguy83/go-md2man v1.0.10/go.mod"
"github.com/creack/pty v1.1.9"
"github.com/creack/pty v1.1.9/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/google/go-dap v0.2.0"
"github.com/google/go-dap v0.2.0/go.mod"
"github.com/google/go-dap v0.3.0"
"github.com/google/go-dap v0.3.0/go.mod"
"github.com/google/go-dap v0.4.0"
"github.com/google/go-dap v0.4.0/go.mod"
"github.com/hashicorp/golang-lru v0.5.4"
"github.com/hashicorp/golang-lru v0.5.4/go.mod"
"github.com/inconshreveable/mousetrap v1.0.0"
"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
"github.com/konsorten/go-windows-terminal-sequences v1.0.3"
"github.com/konsorten/go-windows-terminal-sequences v1.0.3/go.mod"
"github.com/mattn/go-colorable v0.0.0-20170327083344-ded68f7a9561"
"github.com/mattn/go-colorable v0.0.0-20170327083344-ded68f7a9561/go.mod"
"github.com/mattn/go-isatty v0.0.3"
"github.com/mattn/go-isatty v0.0.3/go.mod"
"github.com/peterh/liner v0.0.0-20170317030525-88609521dc4b"
"github.com/peterh/liner v0.0.0-20170317030525-88609521dc4b/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/russross/blackfriday v1.5.2"
"github.com/russross/blackfriday v1.5.2/go.mod"
"github.com/sirupsen/logrus v1.6.0"
"github.com/sirupsen/logrus v1.6.0/go.mod"
"github.com/spf13/cobra v0.0.0-20170417170307-b6cb39589372"
"github.com/spf13/cobra v0.0.0-20170417170307-b6cb39589372/go.mod"
"github.com/spf13/pflag v0.0.0-20170417173400-9e4c21054fa1"
"github.com/spf13/pflag v0.0.0-20170417173400-9e4c21054fa1/go.mod"
"github.com/stretchr/testify v1.2.2"
"github.com/stretchr/testify v1.2.2/go.mod"
"go.starlark.net v0.0.0-20190702223751-32f345186213"
"go.starlark.net v0.0.0-20190702223751-32f345186213/go.mod"
"go.starlark.net v0.0.0-20200821142938-949cc6f4b097"
"go.starlark.net v0.0.0-20200821142938-949cc6f4b097/go.mod"
"golang.org/x/arch v0.0.0-20190927153633-4e8777c89be4"
"golang.org/x/arch v0.0.0-20190927153633-4e8777c89be4/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
"golang.org/x/sys v0.0.0-20190626221950-04f50cda93cb"
"golang.org/x/sys v0.0.0-20190626221950-04f50cda93cb/go.mod"
"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae"
"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae/go.mod"
"golang.org/x/text v0.3.0"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
"golang.org/x/tools v0.0.0-20191127201027-ecd32218bd7f"
"golang.org/x/tools v0.0.0-20191127201027-ecd32218bd7f/go.mod"
"golang.org/x/tools v0.0.0-20200415034506-5d8e1897c761"
"golang.org/x/tools v0.0.0-20200415034506-5d8e1897c761/go.mod"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/yaml.v2 v2.2.1"
"gopkg.in/yaml.v2 v2.2.1/go.mod"
"rsc.io/pdf v0.1.1/go.mod"
)

go-module_set_globals

HOMEPAGE="https://github.com/go-delve/delve"

SRC_URI="https://github.com/go-delve/delve/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

DESCRIPTION="Delve is a debugger for the Go programming language"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
BDEPEND=">dev-lang/go-1.8.0"

src_compile() {
	go build -o "${S}/dlv" ./cmd/dlv || die "build failed"
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin dlv
}
