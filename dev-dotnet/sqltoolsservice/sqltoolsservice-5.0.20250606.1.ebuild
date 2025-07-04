# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGET_APIS=(
	"https://api.nuget.org/v3-flatcontainer"
	"https://www.powershellgallery.com/api/v2"
)
NUGETS="
azure.ai.openai@2.2.0-beta.1
azure.core@1.24.0
azure.core@1.25.0
azure.core@1.35.0
azure.core@1.38.0
azure.core@1.40.0
azure.core@1.41.0
azure.core@1.44.1
azure.identity@1.10.3
azure.identity@1.11.1
azure.identity@1.11.4
azure.identity@1.12.0
azure.identity@1.6.0
azure.identity@1.7.0
azure.resourcemanager.sql@1.0.0
azure.resourcemanager@1.2.0
azure.storage.blobs@12.18.0
azure.storage.common@12.17.0
castle.core@4.2.1
coverlet.collector@6.0.0
coverlet.msbuild@6.0.0
enterpriselibrary.transientfaulthandling.core@2.0.0
humanizer.core@2.14.1
microsoft.applicationinsights@2.21.0
microsoft.applicationinsights@2.23.0
microsoft.azure.keyvault.webkey@3.0.4
microsoft.azure.keyvault@3.0.4
microsoft.azure.kusto.cloud.platform.msal@12.2.3
microsoft.azure.kusto.cloud.platform@12.2.3
microsoft.azure.kusto.data@12.2.3
microsoft.azure.kusto.language@9.0.4
microsoft.azure.management.resourcemanager@3.7.1-preview
microsoft.azure.management.sql@1.41.0-preview
microsoft.azure.operationalinsights@1.0.0
microsoft.bcl.asyncinterfaces@1.1.0
microsoft.bcl.asyncinterfaces@1.1.1
microsoft.bcl.asyncinterfaces@6.0.0
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.bcl.hashcode@1.1.1
microsoft.build.centralpackageversions@2.0.52
microsoft.build.framework@15.9.20
microsoft.build.framework@17.3.2
microsoft.build.tasks.git@1.1.1
microsoft.build.utilities.core@15.9.20
microsoft.build@15.9.20
microsoft.build@17.3.2
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.7.0
microsoft.codeanalysis.csharp.workspaces@4.7.0
microsoft.codeanalysis.csharp@4.7.0
microsoft.codeanalysis.workspaces.common@4.7.0
microsoft.codecoverage@17.7.2
microsoft.csharp@4.3.0
microsoft.csharp@4.5.0
microsoft.csharp@4.7.0
microsoft.data.sqlclient.alwaysencrypted.azurekeyvaultprovider@1.1.1
microsoft.data.sqlclient.sni.runtime@5.1.1
microsoft.data.sqlclient.sni@5.1.1
microsoft.data.sqlclient@1.0.19269.1
microsoft.data.sqlclient@3.1.3
microsoft.data.sqlclient@5.0.1
microsoft.data.sqlclient@5.1.0
microsoft.data.sqlclient@5.1.1
microsoft.data.sqlclient@5.1.5
microsoft.data.sqlclient@5.1.6
microsoft.data.sqlclient@5.2.0
microsoft.extensions.ai.abstractions@9.3.0-preview.1.25114.11
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.2
microsoft.extensions.dependencyinjection@8.0.1
microsoft.extensions.dependencymodel@8.0.0
microsoft.extensions.filesystemglobbing@8.0.0
microsoft.extensions.logging.abstractions@8.0.2
microsoft.extensions.vectordata.abstractions@9.0.0-preview.1.25078.1
microsoft.identity.client.extensions.msal@2.19.3
microsoft.identity.client.extensions.msal@4.60.3
microsoft.identity.client.extensions.msal@4.61.3
microsoft.identity.client@4.39.0
microsoft.identity.client@4.47.1
microsoft.identity.client@4.47.2
microsoft.identity.client@4.56.0
microsoft.identity.client@4.60.3
microsoft.identity.client@4.61.3
microsoft.identitymodel.abstractions@6.22.0
microsoft.identitymodel.abstractions@6.35.0
microsoft.identitymodel.abstractions@7.5.1
microsoft.identitymodel.jsonwebtokens@6.35.0
microsoft.identitymodel.jsonwebtokens@7.5.1
microsoft.identitymodel.logging@6.35.0
microsoft.identitymodel.logging@7.5.1
microsoft.identitymodel.protocols.openidconnect@6.35.0
microsoft.identitymodel.protocols@6.35.0
microsoft.identitymodel.tokens@6.35.0
microsoft.identitymodel.tokens@7.5.1
microsoft.io.recyclablememorystream@3.0.0
microsoft.net.stringtools@17.3.2
microsoft.net.test.sdk@17.7.2
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.platforms@3.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.1.0
microsoft.netcore.targets@1.1.3
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.rest.clientruntime.azure@3.3.18
microsoft.rest.clientruntime.azure@3.3.19
microsoft.rest.clientruntime@2.3.17
microsoft.rest.clientruntime@2.3.19
microsoft.rest.clientruntime@2.3.20
microsoft.rest.clientruntime@2.3.21
microsoft.semantickernel.abstractions@1.38.0
microsoft.semantickernel.connectors.azureopenai@1.38.0
microsoft.semantickernel.connectors.openai@1.38.0
microsoft.semantickernel.core@1.38.0
microsoft.semantickernel@1.38.0
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sqlserver.assessment.authoring@1.1.0
microsoft.sqlserver.assessment@1.0.280
microsoft.sqlserver.assessment@1.1.17
microsoft.sqlserver.assessment@1.1.9
microsoft.sqlserver.dacfx.projects@0.4.0-preview
microsoft.sqlserver.dacfx@162.3.563
microsoft.sqlserver.dacfx@170.0.64-preview
microsoft.sqlserver.dacfx@170.1.31-preview
microsoft.sqlserver.management.smometadataprovider@170.18.0
microsoft.sqlserver.management.sqlparser@160.22523.0
microsoft.sqlserver.management.sqlparser@172.18.0
microsoft.sqlserver.migration.sqltargetprovisioning@1.0.20241022.2
microsoft.sqlserver.migration.tde@1.0.0-preview.1.0.20230914.107
microsoft.sqlserver.server@1.0.0
microsoft.sqlserver.sqlmanagementobjects@170.18.0
microsoft.sqlserver.sqlmanagementobjects@172.64.0
microsoft.sqlserver.transactsql.scriptdom@161.9118.2
microsoft.sqlserver.transactsql.scriptdom@170.44.0
microsoft.sqlserver.types@160.1000.6
microsoft.sqlserver.xevent.xelite@2023.1.30.3
microsoft.testplatform.objectmodel@17.7.2
microsoft.testplatform.testhost@17.7.2
microsoft.visualstudio.testplatform@14.0.0
microsoft.win32.primitives@4.3.0
microsoft.win32.registry@4.3.0
microsoft.win32.registry@4.7.0
microsoft.win32.registry@5.0.0
microsoft.win32.systemevents@5.0.0
microsoft.win32.systemevents@6.0.0
moq@4.8.2
netstandard.library@1.6.0
netstandard.library@1.6.1
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@10.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.3
nuget.frameworks@6.5.0
nunit.console@3.16.3
nunit.consolerunner@3.16.3
nunit.extension.nunitprojectloader@3.6.0
nunit.extension.nunitv2driver@3.8.0
nunit.extension.nunitv2resultwriter@3.6.0
nunit.extension.teamcityeventlistener@1.0.7
nunit.extension.vsprojectloader@3.8.0
nunit3testadapter@4.5.0
nunit@3.13.3
openai@2.2.0-beta.1
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tools@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization.calendars@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.extensions@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding.extensions@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.any.system.threading.timer@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system.data.sqlclient.sni@4.7.0
runtime.native.system.io.compression@4.3.0
runtime.native.system.net.http@4.3.0
runtime.native.system.security.cryptography.apple@4.3.0
runtime.native.system.security.cryptography.apple@4.3.1
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.2
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple@4.3.1
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.2
runtime.unix.microsoft.win32.primitives@4.3.0
runtime.unix.system.console@4.3.1
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.io.filesystem@4.3.0
runtime.unix.system.net.primitives@4.3.0
runtime.unix.system.net.sockets@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
runtime.win-arm64.runtime.native.system.data.sqlclient.sni@4.4.0
runtime.win-x64.runtime.native.system.data.sqlclient.sni@4.4.0
runtime.win-x86.runtime.native.system.data.sqlclient.sni@4.4.0
skiasharp.nativeassets.linux.nodependencies@2.88.6
skiasharp.nativeassets.macos@2.88.6
skiasharp.nativeassets.win32@2.88.6
skiasharp@2.88.6
system.appcontext@4.3.0
system.buffers@4.3.0
system.buffers@4.5.1
system.clientmodel@1.0.0
system.clientmodel@1.1.0
system.clientmodel@1.2.1
system.codedom@4.7.0
system.codedom@6.0.0
system.collections.concurrent@4.0.12
system.collections.concurrent@4.3.0
system.collections.immutable@1.5.0
system.collections.immutable@6.0.0
system.collections.immutable@7.0.0
system.collections.immutable@8.0.0
system.collections.nongeneric@4.3.0
system.collections.specialized@4.3.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.annotations@5.0.0
system.componentmodel.composition@4.7.0
system.componentmodel.composition@8.0.0
system.componentmodel.primitives@4.3.0
system.componentmodel.typeconverter@4.3.0
system.componentmodel@4.0.1
system.componentmodel@4.3.0
system.composition.attributedmodel@7.0.0
system.composition.attributedmodel@8.0.0
system.composition.convention@7.0.0
system.composition.convention@8.0.0
system.composition.hosting@7.0.0
system.composition.hosting@8.0.0
system.composition.runtime@7.0.0
system.composition.runtime@8.0.0
system.composition.typedparts@7.0.0
system.composition.typedparts@8.0.0
system.composition@7.0.0
system.composition@8.0.0
system.configuration.configurationmanager@5.0.0
system.configuration.configurationmanager@6.0.0
system.configuration.configurationmanager@6.0.1
system.configuration.configurationmanager@8.0.0
system.configuration.configurationmanager@9.0.0-rc.2.24473.5
system.console@4.3.0
system.data.odbc@4.7.0
system.data.oledb@6.0.0
system.data.sqlclient@4.8.6
system.diagnostics.contracts@4.0.1
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@4.3.0
system.diagnostics.diagnosticsource@4.6.0
system.diagnostics.diagnosticsource@5.0.0
system.diagnostics.diagnosticsource@5.0.1
system.diagnostics.diagnosticsource@6.0.0
system.diagnostics.diagnosticsource@6.0.1
system.diagnostics.diagnosticsource@8.0.0
system.diagnostics.diagnosticsource@8.0.1
system.diagnostics.eventlog@8.0.0
system.diagnostics.eventlog@9.0.0-rc.2.24473.5
system.diagnostics.performancecounter@5.0.0
system.diagnostics.performancecounter@6.0.0
system.diagnostics.tools@4.3.0
system.diagnostics.tracesource@4.0.0
system.diagnostics.tracesource@4.3.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.drawing.common@5.0.3
system.drawing.common@6.0.0
system.dynamic.runtime@4.0.11
system.dynamic.runtime@4.3.0
system.formats.asn1@5.0.0
system.globalization.calendars@4.3.0
system.globalization.extensions@4.3.0
system.globalization@4.0.11
system.globalization@4.3.0
system.identitymodel.tokens.jwt@6.35.0
system.identitymodel.tokens.jwt@7.5.1
system.io.compression.zipfile@4.3.0
system.io.compression@4.3.0
system.io.filesystem.accesscontrol@5.0.0
system.io.filesystem.primitives@4.3.0
system.io.filesystem@4.3.0
system.io.hashing@6.0.0
system.io.packaging@8.0.0
system.io.packaging@8.0.1
system.io.packaging@9.0.0-rc.2.24473.5
system.io.pipelines@7.0.0
system.io@4.1.0
system.io@4.3.0
system.linq.expressions@4.1.0
system.linq.expressions@4.3.0
system.linq.queryable@4.3.0
system.linq@4.1.0
system.linq@4.3.0
system.management@6.0.0
system.memory.data@1.0.2
system.memory.data@6.0.0
system.memory@4.5.3
system.memory@4.5.4
system.memory@4.5.5
system.net.http@4.3.0
system.net.http@4.3.4
system.net.nameresolution@4.3.0
system.net.primitives@4.3.0
system.net.sockets@4.3.0
system.numerics.tensors@8.0.0
system.numerics.vectors@4.4.0
system.numerics.vectors@4.5.0
system.objectmodel@4.0.12
system.objectmodel@4.3.0
system.private.uri@4.3.0
system.private.uri@4.3.2
system.reactive.core@3.1.1
system.reactive.core@6.0.0
system.reactive.interfaces@3.1.1
system.reactive@6.0.0
system.reflection.emit.ilgeneration@4.3.0
system.reflection.emit.lightweight@4.3.0
system.reflection.emit@4.0.1
system.reflection.emit@4.3.0
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadata@6.0.0
system.reflection.metadata@7.0.0
system.reflection.metadataloadcontext@6.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.3.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.extensions@4.7.1
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.caching@6.0.0
system.runtime.caching@8.0.0
system.runtime.caching@8.0.1
system.runtime.caching@9.0.0-rc.2.24473.5
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@4.7.1
system.runtime.compilerservices.unsafe@5.0.0
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.3.0
system.runtime.loader@4.0.0
system.runtime.loader@4.3.0
system.runtime.numerics@4.3.0
system.runtime.serialization.formatters@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime.serialization.primitives@4.3.0
system.runtime@4.1.0
system.runtime@4.3.0
system.runtime@4.3.1
system.security.accesscontrol@4.7.0
system.security.accesscontrol@5.0.0
system.security.accesscontrol@6.0.0
system.security.cryptography.algorithms@4.3.0
system.security.cryptography.algorithms@4.3.1
system.security.cryptography.cng@4.3.0
system.security.cryptography.cng@4.5.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.csp@4.3.0
system.security.cryptography.encoding@4.3.0
system.security.cryptography.openssl@4.3.0
system.security.cryptography.primitives@4.3.0
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.protecteddata@4.7.0
system.security.cryptography.protecteddata@5.0.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.protecteddata@9.0.0-rc.2.24473.5
system.security.cryptography.x509certificates@4.3.0
system.security.cryptography.x509certificates@4.3.2
system.security.permissions@5.0.0
system.security.permissions@6.0.0
system.security.permissions@8.0.0
system.security.principal.windows@4.3.0
system.security.principal.windows@4.7.0
system.security.principal.windows@5.0.0
system.security.principal@4.3.0
system.text.encoding.codepages@4.0.1
system.text.encoding.codepages@4.4.0
system.text.encoding.codepages@6.0.0
system.text.encoding.codepages@8.0.0
system.text.encoding.extensions@4.3.0
system.text.encoding@4.3.0
system.text.encodings.web@4.7.1
system.text.encodings.web@4.7.2
system.text.encodings.web@5.0.1
system.text.encodings.web@6.0.0
system.text.encodings.web@8.0.0
system.text.json@4.6.0
system.text.json@4.7.2
system.text.json@5.0.0
system.text.json@6.0.0
system.text.json@6.0.10
system.text.json@8.0.0
system.text.json@8.0.1
system.text.json@8.0.5
system.text.regularexpressions@4.3.0
system.threading.channels@7.0.0
system.threading.tasks.dataflow@4.6.0
system.threading.tasks.dataflow@6.0.0
system.threading.tasks.extensions@4.3.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.0.0
system.threading.threadpool@4.0.10
system.threading.threadpool@4.3.0
system.threading.timer@4.3.0
system.threading@4.0.11
system.threading@4.3.0
system.valuetuple@4.4.0
system.valuetuple@4.5.0
system.windows.extensions@5.0.0
system.windows.extensions@6.0.0
system.windows.extensions@8.0.0
system.xml.readerwriter@4.3.0
system.xml.xdocument@4.3.0
system.xml.xmldocument@4.3.0
textcopy@6.2.1
xunit.abstractions@2.0.3
xunit.analyzers@1.3.0
xunit.assert@2.5.1
xunit.core@2.5.1
xunit.extensibility.core@2.5.1
xunit.extensibility.execution@2.5.1
xunit@2.5.1
"

inherit dotnet-pkg

DESCRIPTION="SQL Tools API service that provides SQL Server data management capabilities."
HOMEPAGE="https://github.com/microsoft/sqltoolsservice"

SRC_URI="
	https://github.com/microsoft/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	${NUGET_URIS}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-dotnet/skia-sharp"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-net8.0.patch
)

DOTNET_PKG_PROJECTS=(
	src/Microsoft.SqlTools.ServiceLayer/Microsoft.SqlTools.ServiceLayer.csproj
	src/Microsoft.SqlTools.ResourceProvider/Microsoft.SqlTools.ResourceProvider.csproj
	src/Microsoft.SqlTools.Migration/Microsoft.SqlTools.Migration.csproj
	src/Microsoft.Kusto.ServiceLayer/Microsoft.Kusto.ServiceLayer.csproj
)

pkg_setup() {
	dotnet-pkg_pkg_setup
}

src_prepare() {
	dotnet-pkg_src_prepare

	# make CA errors, warnings
	sed -i 's/error/warning/g' .editorconfig || die

	# fix casing
	for i in $(find ./src -name "*pt-br*"); do rename pt-br pt-BR $i; done
	for i in $(find ./src -name "*zh-hans*"); do rename zh-hans zh-Hans $i; done
	for i in $(find ./src -name "*zh-hant*"); do rename zh-hant zh-Hant $i; done

	# copy private nuget packages
	cp -r "${S}"/bin/nuget/*.nupkg "${NUGET_PACKAGES}/" || die
}

src_compile() {
	dotnet-pkg_src_compile
}

src_install() {
	local dest_root="/usr/lib/${PN}"

	dotnet-pkg-base_install "${dest_root}"

	echo "MSSQL_SQLTOOLSSERVICE=\"${dest_root}\"" > "${T}"/50${PN} || die
	doenvd "${T}"/50${PN}

	# Remove "libSkiaSharp.so" provided by "skia-sharp"
	rm "${ED}/${dest_root}/libSkiaSharp.so"

	# remove executable bits
	find "${ED}/${dest_root}" -type f -exec chmod -x {} \;

	# restore executabe bit for executables
	pushd "${ED}/${dest_root}" >/dev/null || die
	chmod +x MicrosoftKustoServiceLayer || die
	chmod +x MicrosoftSqlToolsServiceLayer || die
	chmod +x MicrosoftSqlToolsMigration || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
	popd >/dev/null
}
