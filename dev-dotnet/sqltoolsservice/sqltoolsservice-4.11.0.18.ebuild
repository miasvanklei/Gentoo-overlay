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
	dev-dotnet/skia-sharp
	virtual/dotnet-core:8
"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="
	/usr/share/dotnet/sqltoolsservice/MicrosoftKustoServiceLayer
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsCredentials
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsMigration
	/usr/share/dotnet/sqltoolsservice/MicrosoftSqlToolsServiceLayer
	/usr/share/dotnet/sqltoolsservice/SqlToolsResourceProviderService
"

BUILD_DIR="${WORKDIR}/${P}_build"

publish_sqltool()
{
	einfo "Building $1"
	pushd src/$1 >/dev/null
	dotnet publish -c release -o "${BUILD_DIR}" || die
	popd >/dev/null
}

src_prepare() {
	rm global.json

	# make CA errors, warnings
	sed -i 's/error/warning/g' .editorconfig

	# update .net version
	grep -rl "net7.0" --include \*.csproj . | xargs sed -i 's/net7.0/net8.0/g'

	# fix casing
	for i in $(find -name "*pt-br*"); do rename pt-br pt-BR $i; done
	for i in $(find -name "*zh-hans*"); do rename zh-hans zh-Hans $i; done
	for i in $(find -name "*zh-hant*"); do rename zh-hant zh-Hant $i; done

	eapply "${FILESDIR}"/fix-net8.0.patch

	default
}

src_compile() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1

	publish_sqltool Microsoft.SqlTools.ServiceLayer
	publish_sqltool Microsoft.SqlTools.ResourceProvider
	publish_sqltool Microsoft.SqlTools.Migration
	publish_sqltool Microsoft.Kusto.ServiceLayer
}

src_install() {
	local installdir="/usr/share/dotnet/${PN}"
	insinto ${installdir}
	doins -r ${BUILD_DIR}/*

	find "{D}/usr/share/dotnet/${PN}" -name "libSkiaSharp.so" -delete

	# fix executable bit
	pushd ${D}/${installdir} >/dev/null || die
	chmod +x MicrosoftKustoServiceLayer || die
	chmod +x MicrosoftSqlToolsServiceLayer || die
	chmod +x MicrosoftSqlToolsMigration || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
}
