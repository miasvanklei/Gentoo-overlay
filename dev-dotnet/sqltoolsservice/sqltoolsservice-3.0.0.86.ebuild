# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="SQL Tools API service that provides SQL Server data management capabilities."
HOMEPAGE="https://github.com/microsoft/sqltoolsservice"
LICENSE="MIT"

MY_PV="$(ver_cut 0-3)-release.$(ver_cut 4-)"

SRC_URI="https://github.com/microsoft/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/microsoft/sqltoolsservice/raw/9fc5dfa64753c335a63c9b0f7350783f17f8622d/bin/nuget/Microsoft.SqlServer.Migration.Assessment.1.0.20201001.204.nupkg
	https://github.com/microsoft/sqltoolsservice/raw/9fc5dfa64753c335a63c9b0f7350783f17f8622d/bin/nuget/Microsoft.SqlServer.TransactSql.ScriptDom.NRT.1.2.65626.134.nupkg
"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-dotnet/dotnet-core"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/fix-nuget.patch
)

QA_PRESTRIPPED="
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsServiceLayer
	/usr/share/dotnet/sqltoolsservice/SqlToolsResourceProviderService
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsCredentials
"

build_sqltool()
{
	pushd src/Microsoft.SqlTools.$1 >/dev/null
	dotnet restore
	dotnet publish -c release -o "${WORKDIR}/sqltoolsservice" || die
	popd
}

src_unpack(){
	unpack ${P}.tar.gz
	mkdir ${S}/bin/nuget || die
	cp  ${DISTDIR}/*.nupkg ${S}/bin/nuget/ || die
}

src_compile() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1

	build_sqltool ServiceLayer
	build_sqltool ResourceProvider
}

src_install() {
	insinto /usr/share/dotnet
	doins -r ${WORKDIR}/sqltoolsservice

	# fix executable bit
	pushd ${D}/usr/share/dotnet/sqltoolsservice >/dev/null || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
	chmod +x MicrosoftSqlToolsServiceLayer || die
}
