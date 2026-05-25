# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=10.0
NUGET_APIS=(
	"https://api.nuget.org/v3-flatcontainer"
	"https://www.powershellgallery.com/api/v2"
)
NUGETS="
azure.ai.openai@2.7.0-beta.2
azure.core@1.25.0
azure.core@1.35.0
azure.core@1.41.0
azure.core@1.47.1
azure.core@1.50.0
azure.identity@1.10.3
azure.identity@1.14.2
azure.identity@1.17.1
azure.identity@1.7.0
azure.resourcemanager.sql@1.0.0
azure.resourcemanager@1.2.0
azure.storage.blobs@12.18.0
azure.storage.blobs@12.27.0
azure.storage.common@12.17.0
azure.storage.common@12.26.0
castle.core@4.2.1
coverlet.collector@6.0.0
coverlet.msbuild@6.0.0
enterpriselibrary.transientfaulthandling.core@2.0.0
exceldatareader@3.6.0
humanizer.core@2.14.1
microsoft.applicationinsights@2.21.0
microsoft.applicationinsights@2.23.0
microsoft.azure.keyvault.webkey@3.0.4
microsoft.azure.keyvault@3.0.4
microsoft.azure.management.resourcemanager@3.7.1-preview
microsoft.azure.management.sql@1.41.0-preview
microsoft.bcl.asyncinterfaces@10.0.2
microsoft.bcl.asyncinterfaces@10.0.3
microsoft.bcl.asyncinterfaces@10.0.5
microsoft.bcl.asyncinterfaces@7.0.0
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.bcl.asyncinterfaces@9.0.5
microsoft.bcl.asyncinterfaces@9.0.9
microsoft.bcl.cryptography@8.0.0
microsoft.bcl.hashcode@1.1.1
microsoft.bcl.memory@10.0.5
microsoft.bcl.numerics@10.0.2
microsoft.build.centralpackageversions@2.0.52
microsoft.build.framework@15.9.20
microsoft.build.framework@17.11.48
microsoft.build.tasks.git@1.1.1
microsoft.build.utilities.core@15.9.20
microsoft.build@15.9.20
microsoft.build@17.11.48
microsoft.codeanalysis.analyzers@3.3.4
microsoft.codeanalysis.common@4.7.0
microsoft.codeanalysis.csharp.workspaces@4.7.0
microsoft.codeanalysis.csharp@4.7.0
microsoft.codeanalysis.workspaces.common@4.7.0
microsoft.codecoverage@17.7.2
microsoft.csharp@4.5.0
microsoft.data.sqlclient.alwaysencrypted.azurekeyvaultprovider@1.1.1
microsoft.data.sqlclient.sni.runtime@6.0.2
microsoft.data.sqlclient.sni@6.0.2
microsoft.data.sqlclient@1.0.19269.1
microsoft.data.sqlclient@5.0.1
microsoft.data.sqlclient@5.1.0
microsoft.data.sqlclient@5.1.1
microsoft.data.sqlclient@5.1.5
microsoft.data.sqlclient@5.1.6
microsoft.data.sqlclient@5.2.0
microsoft.data.sqlclient@6.1.3
microsoft.data.sqlclient@6.1.4
microsoft.extensions.ai.abstractions@10.0.1
microsoft.extensions.ai.abstractions@10.2.0
microsoft.extensions.ai.abstractions@9.5.0
microsoft.extensions.ai.openai@10.0.1-preview.1.25571.5
microsoft.extensions.ai@10.2.0
microsoft.extensions.caching.abstractions@10.0.2
microsoft.extensions.caching.abstractions@8.0.0
microsoft.extensions.caching.abstractions@9.0.11
microsoft.extensions.caching.memory@8.0.1
microsoft.extensions.caching.memory@9.0.11
microsoft.extensions.dependencyinjection.abstractions@10.0.2
microsoft.extensions.dependencyinjection.abstractions@7.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.2
microsoft.extensions.dependencyinjection.abstractions@9.0.11
microsoft.extensions.dependencyinjection@10.0.2
microsoft.extensions.dependencymodel@10.0.3
microsoft.extensions.dependencymodel@10.0.5
microsoft.extensions.dependencymodel@5.0.0
microsoft.extensions.filesystemglobbing@10.0.5
microsoft.extensions.filesystemglobbing@8.0.0
microsoft.extensions.logging.abstractions@10.0.2
microsoft.extensions.logging.abstractions@8.0.2
microsoft.extensions.logging.abstractions@8.0.3
microsoft.extensions.logging.abstractions@9.0.11
microsoft.extensions.options@8.0.2
microsoft.extensions.options@9.0.11
microsoft.extensions.primitives@10.0.2
microsoft.extensions.primitives@8.0.0
microsoft.extensions.primitives@9.0.11
microsoft.extensions.vectordata.abstractions@9.7.0
microsoft.identity.client.extensions.msal@4.78.0
microsoft.identity.client.extensions.msal@4.81.0
microsoft.identity.client@4.47.2
microsoft.identity.client@4.56.0
microsoft.identity.client@4.78.0
microsoft.identity.client@4.80.0
microsoft.identity.client@4.81.0
microsoft.identitymodel.abstractions@7.7.1
microsoft.identitymodel.abstractions@8.14.0
microsoft.identitymodel.jsonwebtokens@7.7.1
microsoft.identitymodel.logging@7.7.1
microsoft.identitymodel.protocols.openidconnect@7.7.1
microsoft.identitymodel.protocols@7.7.1
microsoft.identitymodel.tokens@7.7.1
microsoft.net.stringtools@17.11.48
microsoft.net.test.sdk@17.7.2
microsoft.netcore.platforms@1.0.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.netcore.platforms@3.1.0
microsoft.netcore.platforms@5.0.0
microsoft.netcore.targets@1.0.1
microsoft.netcore.targets@1.1.0
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
microsoft.programsynthesis.common@10.10.3
microsoft.programsynthesis.conditionals@10.10.3
microsoft.programsynthesis.detection@10.10.3
microsoft.programsynthesis.extraction.json@10.10.3
microsoft.programsynthesis.extraction.text@10.10.3
microsoft.programsynthesis.read.flatfile@10.10.3
microsoft.programsynthesis.split.text@10.10.3
microsoft.programsynthesis.transformation.text@10.10.3
microsoft.rest.clientruntime.azure@3.3.18
microsoft.rest.clientruntime.azure@3.3.19
microsoft.rest.clientruntime@2.3.19
microsoft.rest.clientruntime@2.3.20
microsoft.rest.clientruntime@2.3.21
microsoft.semantickernel.abstractions@1.71.0
microsoft.semantickernel.connectors.azureopenai@1.71.0
microsoft.semantickernel.connectors.openai@1.71.0
microsoft.semantickernel.core@1.71.0
microsoft.semantickernel@1.71.0
microsoft.sourcelink.common@1.1.1
microsoft.sourcelink.github@1.1.1
microsoft.sqlpackage.core@0.1.75-preview
microsoft.sqlserver.assessment.authoring@1.1.0
microsoft.sqlserver.assessment@1.0.280
microsoft.sqlserver.assessment@1.1.17
microsoft.sqlserver.assessment@1.1.9
microsoft.sqlserver.dacfx.projects@0.6.3-preview
microsoft.sqlserver.dacfx@162.3.563
microsoft.sqlserver.dacfx@170.2.70
microsoft.sqlserver.dacfx@170.4.63-preview
microsoft.sqlserver.management.smometadataprovider@181.15.0
microsoft.sqlserver.management.sqlparser@173.0.0
microsoft.sqlserver.management.sqlparser@173.8.0
microsoft.sqlserver.migration.sqltargetprovisioning@1.0.20241022.2
microsoft.sqlserver.migration.tde@1.0.0-preview.1.0.20230914.107
microsoft.sqlserver.server@1.0.0
microsoft.sqlserver.sqlmanagementobjects@170.18.0
microsoft.sqlserver.sqlmanagementobjects@181.15.0
microsoft.sqlserver.transactsql.scriptdom@161.9118.2
microsoft.sqlserver.transactsql.scriptdom@170.128.0
microsoft.sqlserver.transactsql.scriptdom@180.6.0
microsoft.sqlserver.types@160.1000.6
microsoft.sqlserver.types@170.1000.7
microsoft.sqlserver.xevent.xelite@2023.1.30.3
microsoft.testplatform.objectmodel@17.7.2
microsoft.testplatform.testhost@17.7.2
microsoft.visualstudio.testplatform@14.0.0
microsoft.win32.registry@4.3.0
microsoft.win32.systemevents@10.0.5
moq@4.8.2
netstandard.library@1.6.0
netstandard.library@1.6.1
netstandard.library@2.0.0
netstandard.library@2.0.3
newtonsoft.json@10.0.3
newtonsoft.json@13.0.1
newtonsoft.json@13.0.2
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
openai@2.7.0
runtime.any.system.collections@4.3.0
runtime.any.system.diagnostics.tracing@4.3.0
runtime.any.system.globalization@4.3.0
runtime.any.system.io@4.3.0
runtime.any.system.reflection.extensions@4.3.0
runtime.any.system.reflection.primitives@4.3.0
runtime.any.system.reflection@4.3.0
runtime.any.system.resources.resourcemanager@4.3.0
runtime.any.system.runtime.handles@4.3.0
runtime.any.system.runtime.interopservices@4.3.0
runtime.any.system.runtime@4.3.0
runtime.any.system.text.encoding@4.3.0
runtime.any.system.threading.tasks@4.3.0
runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system.io.compression@4.3.0
runtime.native.system.security.cryptography.openssl@4.3.0
runtime.native.system@4.0.0
runtime.native.system@4.3.0
runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl@4.3.0
runtime.unix.system.diagnostics.debug@4.3.0
runtime.unix.system.private.uri@4.3.0
runtime.unix.system.runtime.extensions@4.3.0
skiasharp.nativeassets.linux.nodependencies@2.88.6
skiasharp.nativeassets.macos@2.88.6
skiasharp.nativeassets.win32@2.88.6
skiasharp@2.88.6
system.buffers@4.3.0
system.buffers@4.5.1
system.buffers@4.6.1
system.clientmodel@1.8.0
system.clientmodel@1.8.1
system.codedom@4.7.0
system.codedom@6.0.0
system.codedom@8.0.0
system.collections.concurrent@4.0.12
system.collections.immutable@1.5.0
system.collections@4.0.11
system.collections@4.3.0
system.componentmodel.annotations@5.0.0
system.componentmodel.composition@4.7.0
system.componentmodel.composition@8.0.0
system.composition.attributedmodel@10.0.5
system.composition.attributedmodel@7.0.0
system.composition.convention@10.0.5
system.composition.convention@7.0.0
system.composition.hosting@10.0.5
system.composition.hosting@7.0.0
system.composition.runtime@10.0.5
system.composition.runtime@7.0.0
system.composition.typedparts@10.0.5
system.composition.typedparts@7.0.0
system.composition@10.0.5
system.composition@7.0.0
system.configuration.configurationmanager@10.0.5
system.configuration.configurationmanager@5.0.0
system.configuration.configurationmanager@6.0.0
system.configuration.configurationmanager@8.0.0
system.configuration.configurationmanager@9.0.11
system.data.common@4.3.0
system.data.odbc@4.7.0
system.data.oledb@6.0.0
system.data.oledb@8.0.0
system.diagnostics.debug@4.0.11
system.diagnostics.debug@4.3.0
system.diagnostics.diagnosticsource@10.0.2
system.diagnostics.diagnosticsource@5.0.0
system.diagnostics.diagnosticsource@6.0.1
system.diagnostics.diagnosticsource@8.0.1
system.diagnostics.eventlog@10.0.5
system.diagnostics.eventlog@8.0.0
system.diagnostics.eventlog@9.0.11
system.diagnostics.performancecounter@5.0.0
system.diagnostics.performancecounter@6.0.0
system.diagnostics.performancecounter@8.0.0
system.diagnostics.tracesource@4.0.0
system.diagnostics.tracing@4.1.0
system.diagnostics.tracing@4.3.0
system.drawing.common@10.0.5
system.dynamic.runtime@4.0.11
system.formats.asn1@8.0.1
system.globalization@4.0.11
system.globalization@4.3.0
system.identitymodel.tokens.jwt@7.7.1
system.io.compression@4.3.0
system.io.filesystem.accesscontrol@5.0.0
system.io.hashing@10.0.1
system.io.hashing@6.0.0
system.io.packaging@10.0.3
system.io.packaging@10.0.5
system.io.packaging@8.0.0
system.io.packaging@8.0.1
system.io.pipelines@10.0.2
system.io.pipelines@10.0.3
system.io.pipelines@10.0.5
system.io@4.1.0
system.io@4.3.0
system.linq.asyncenumerable@10.0.2
system.linq.expressions@4.1.0
system.linq@4.1.0
system.management@6.0.0
system.management@8.0.0
system.memory.data@10.0.0
system.memory.data@8.0.1
system.memory@4.5.4
system.memory@4.5.5
system.memory@4.6.3
system.net.serversentevents@9.0.9
system.numerics.tensors@10.0.2
system.numerics.vectors@4.5.0
system.numerics.vectors@4.6.1
system.objectmodel@4.0.12
system.private.uri@4.3.0
system.reactive.core@3.1.1
system.reactive.core@6.0.0
system.reactive.interfaces@3.1.1
system.reactive@6.0.0
system.reflection.emit.ilgeneration@4.0.1
system.reflection.emit.lightweight@4.0.1
system.reflection.emit@4.0.1
system.reflection.extensions@4.0.1
system.reflection.extensions@4.3.0
system.reflection.metadata@1.6.0
system.reflection.metadataloadcontext@8.0.0
system.reflection.primitives@4.0.1
system.reflection.primitives@4.3.0
system.reflection.typeextensions@4.1.0
system.reflection.typeextensions@4.4.0
system.reflection@4.1.0
system.reflection@4.3.0
system.resources.extensions@4.7.1
system.resources.resourcemanager@4.0.1
system.resources.resourcemanager@4.3.0
system.runtime.caching@10.0.5
system.runtime.caching@8.0.0
system.runtime.caching@8.0.1
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.runtime.compilerservices.unsafe@6.1.0
system.runtime.compilerservices.unsafe@6.1.2
system.runtime.extensions@4.1.0
system.runtime.extensions@4.3.0
system.runtime.handles@4.0.1
system.runtime.handles@4.3.0
system.runtime.interopservices.runtimeinformation@4.3.0
system.runtime.interopservices@4.1.0
system.runtime.interopservices@4.3.0
system.runtime.loader@4.0.0
system.runtime.loader@4.3.0
system.runtime.serialization.primitives@4.1.1
system.runtime@4.1.0
system.runtime@4.3.0
system.security.accesscontrol@5.0.0
system.security.accesscontrol@6.0.0
system.security.cryptography.cng@4.5.0
system.security.cryptography.cng@5.0.0
system.security.cryptography.pkcs@8.0.1
system.security.cryptography.pkcs@9.0.11
system.security.cryptography.protecteddata@10.0.5
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.protecteddata@5.0.0
system.security.cryptography.protecteddata@6.0.0
system.security.cryptography.protecteddata@8.0.0
system.security.cryptography.protecteddata@9.0.11
system.security.cryptography.protecteddata@9.0.4
system.security.permissions@10.0.5
system.security.permissions@5.0.0
system.security.permissions@6.0.0
system.security.permissions@8.0.0
system.security.principal.windows@4.3.0
system.security.principal.windows@5.0.0
system.text.encoding.codepages@4.0.1
system.text.encoding.codepages@4.4.0
system.text.encoding@4.0.11
system.text.encoding@4.3.0
system.text.encodings.web@10.0.2
system.text.encodings.web@10.0.3
system.text.encodings.web@10.0.5
system.text.encodings.web@8.0.0
system.text.json@10.0.0
system.text.json@10.0.2
system.text.json@10.0.3
system.text.json@10.0.5
system.text.json@8.0.4
system.text.json@8.0.5
system.text.json@8.0.6
system.text.regularexpressions@4.3.1
system.threading.channels@10.0.2
system.threading.tasks.dataflow@4.6.0
system.threading.tasks.extensions@4.5.4
system.threading.tasks.extensions@4.6.0
system.threading.tasks.extensions@4.6.3
system.threading.tasks@4.0.11
system.threading.tasks@4.3.0
system.threading.thread@4.0.0
system.threading@4.0.11
system.threading@4.3.0
system.valuetuple@4.5.0
system.valuetuple@4.6.1
system.windows.extensions@10.0.5
system.windows.extensions@5.0.0
system.windows.extensions@8.0.0
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
	src/Microsoft.SqlTools.ResourceProvider/Microsoft.SqlTools.ResourceProvider.csproj
	src/Microsoft.SqlTools.ServiceLayer/Microsoft.SqlTools.ServiceLayer.csproj
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
	chmod +x MicrosoftSqlToolsServiceLayer || die
	chmod +x MicrosoftSqlToolsCredentials || die
	chmod +x SqlToolsResourceProviderService || die
	popd >/dev/null
}
