# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SQL Tools API service that provides SQL Server data management capabilities."
HOMEPAGE="https://github.com/microsoft/sqltoolsservice"
LICENSE="MIT"

SRC_URI="https://github.com/microsoft/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

RDEPEND="
	virtual/dotnet-core"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsServiceLayer
	/usr/share/dotnet/sqltoolsservice/SqlToolsResourceProviderService
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsCredentials
"

BUILD_DIR="${WORKDIR}/${P}_build"

PATCHES=(
#	"${FILESDIR}"/fix-build.patch
)

publish_sqltool()
{
	pushd src/Microsoft.SqlTools.$1 >/dev/null
	dotnet publish -c release -o "${BUILD_DIR}" || die
	popd
}

src_prepare() {
	rm global.json

	# fix casing
	mkdir -p ${BUILD_DIR}/pt-BR
	mkdir -p ${BUILD_DIR}/zh-hans
	mkdir -p ${BUILD_DIR}/zh-hant
	mkdir -p ${S}/src/Microsoft.SqlTools.ServiceLayer/bin/release/net7.0/zh-hans
	mkdir -p ${S}/src/Microsoft.SqlTools.ServiceLayer/bin/release/net7.0/zh-hant
	mkdir -p ${S}/src/Microsoft.SqlTools.ServiceLayer/bin/release/net7.0/pt-br

	default
}

src_compile() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1


	publish_sqltool ServiceLayer
	publish_sqltool ResourceProvider
}

src_install() {
	local installdir="/usr/share/dotnet/${PN}"
	insinto ${installdir}
	doins -r ${BUILD_DIR}/*

	# fix executable bit
	pushd ${D}/${installdir} >/dev/null || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
	chmod +x MicrosoftSqlToolsServiceLayer || die
}
