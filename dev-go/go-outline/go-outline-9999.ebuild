# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go-module

EGO_SUM=(
"github.com/yuin/goldmark v1.2.1/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
"golang.org/x/mod v0.3.0"
"golang.org/x/mod v0.3.0/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
"golang.org/x/sys v0.0.0-20210119212857-b64e53b001e4"
"golang.org/x/sys v0.0.0-20210119212857-b64e53b001e4/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
"golang.org/x/tools v0.1.0"
"golang.org/x/tools v0.1.0/go.mod"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
)

go-module_set_globals

DESCRIPTION="Utility to extract JSON representation of declarations from a Go source file"
HOMEPAGE="https://github.com/ramya-rao-a/go-outline"
EGIT_REPO_URI="https://github.com/ramya-rao-a/go-outline.git"
SRC_URI="${EGO_SUM_SRC_URI}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=(
	dev-lang/go
)

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	cat <<- EOF > ${S}/go.mod
		module go-outline

		go 1.16
	EOF

	go-module_src_unpack
}

src_compile() {
	go build -o go-outline main.go || die
}

src_install() {
	dobin go-outline
}
