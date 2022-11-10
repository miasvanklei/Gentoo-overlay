# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="SQL Tools API service that provides SQL Server data management capabilities."
HOMEPAGE="https://github.com/microsoft/sqltoolsservice"
LICENSE="MIT"

SRC_URI="https://github.com/microsoft/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

RDEPEND="
	=dev-dotnet/dotnet-sdk-7.0.100
	virtual/dotnet-core"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsServiceLayer
	/usr/share/dotnet/sqltoolsservice/SqlToolsResourceProviderService
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsCredentials
"

PATCHES=(
	"${FILESDIR}"/fix-resources.patch
	"${FILESDIR}"/update-sdk.patch
)

publish_sqltool()
{
	pushd src/Microsoft.SqlTools.$1 >/dev/null
	dotnet publish -c release -o "${WORKDIR}/sqltoolsservice" || die
	popd
}

src_compile() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1

	mkdir -p ${WORKDIR}/sqltoolsservice/zh-hans
	mkdir -p ${WORKDIR}/sqltoolsservice/zh-hant

	publish_sqltool ServiceLayer
	publish_sqltool ResourceProvider
}

src_install() {
	insinto /usr/share/dotnet
	doins -r ${WORKDIR}/sqltoolsservice

	# fix executable bit
	pushd ${D}/usr/share/dotnet/sqltoolsservice >/dev/null || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
	chmod +x MicrosoftSqlToolsServiceLayer || die

	cp runtimes/unix/lib/netcoreapp3.1/*.dll ./ || die
}
