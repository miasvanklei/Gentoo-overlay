# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=10.0
NUGET_APIS=(
	"https://api.nuget.org/v3-flatcontainer"
	"https://pkgs.dev.azure.com/azfunc/public/_packaging/upstream-public/nuget/v3/flat2"
	"https://azfunc.pkgs.visualstudio.com/e6a70c92-4128-439f-8012-382fe78d6396/_packaging/Microsoft.Azure.Functions.PowerShellWorker/nuget/v3/flat2"
	"https://azfunc.pkgs.visualstudio.com/e6a70c92-4128-439f-8012-382fe78d6396/_packaging/AzureFunctions/nuget/v3/flat2"
	"https://azfunc.pkgs.visualstudio.com/e6a70c92-4128-439f-8012-382fe78d6396/_packaging/AzureFunctionsRelease/nuget/v3/flat2"
	"https://azfunc.pkgs.visualstudio.com/e6a70c92-4128-439f-8012-382fe78d6396/_packaging/AzureFunctionsTempStaging/nuget/v3/flat2"
	"https://pkgs.dev.azure.com/azfunc/public/_packaging/infra/nuget/v3/flat2"
)
NUGETS="
accentedcommandlineparser@2.0.1
aspnetcore.healthchecks.ui.client@9.0.0
aspnetcore.healthchecks.ui.core@9.0.0
autofac@9.3.1
azure.core@1.37.0
azure.core@1.41.0
azure.core@1.47.3
azure.core@1.50.0
azure.data.tables@12.9.0
azure.functions.rpc.server@4.1054.250
azure.identity@1.17.1
azure.monitor.opentelemetry.exporter@1.5.0
azure.security.keyvault.secrets@4.6.0
azure.storage.blobs@12.22.1
azure.storage.common@12.21.0
azure.storage.common@12.25.0
azure.storage.files.shares@12.24.0
colors.net@1.1.0
dynamitey@2.0.9.136
google.protobuf@3.23.1
grpc.aspnetcore.server.clientfactory@2.55.0
grpc.aspnetcore.server@2.55.0
grpc.aspnetcore@2.55.0
grpc.core.api@2.55.0
grpc.net.client@2.55.0
grpc.net.clientfactory@2.55.0
grpc.net.common@2.55.0
grpc.tools@2.55.1
impromptuinterface@7.0.1
microsoft.applicationinsights.aspnetcore@2.23.0
microsoft.applicationinsights.dependencycollector@2.23.0
microsoft.applicationinsights.eventcountercollector@2.23.0
microsoft.applicationinsights.perfcountercollector@2.23.0
microsoft.applicationinsights.snapshotcollector@1.4.6
microsoft.applicationinsights.windowsserver.telemetrychannel@2.23.0
microsoft.applicationinsights.windowsserver@2.23.0
microsoft.applicationinsights@2.23.0
microsoft.aspnet.webapi.client@5.2.7
microsoft.aspnet.webapi.client@5.2.9
microsoft.aspnetcore.antiforgery@2.2.0
microsoft.aspnetcore.authentication.abstractions@2.3.0
microsoft.aspnetcore.authentication.core@2.3.0
microsoft.aspnetcore.authentication.jwtbearer@10.0.0
microsoft.aspnetcore.authorization.policy@2.3.0
microsoft.aspnetcore.authorization@2.3.0
microsoft.aspnetcore.cors@2.2.0
microsoft.aspnetcore.cryptography.internal@10.0.9
microsoft.aspnetcore.dataprotection.abstractions@10.0.9
microsoft.aspnetcore.dataprotection@10.0.9
microsoft.aspnetcore.diagnostics.abstractions@2.2.0
microsoft.aspnetcore.hosting.abstractions@2.1.1
microsoft.aspnetcore.hosting.abstractions@2.3.0
microsoft.aspnetcore.hosting.server.abstractions@2.1.1
microsoft.aspnetcore.hosting.server.abstractions@2.3.0
microsoft.aspnetcore.hosting@2.1.1
microsoft.aspnetcore.html.abstractions@2.2.0
microsoft.aspnetcore.http.abstractions@2.1.1
microsoft.aspnetcore.http.abstractions@2.2.0
microsoft.aspnetcore.http.abstractions@2.3.0
microsoft.aspnetcore.http.extensions@2.1.1
microsoft.aspnetcore.http.extensions@2.2.0
microsoft.aspnetcore.http.extensions@2.3.0
microsoft.aspnetcore.http.features@2.1.1
microsoft.aspnetcore.http.features@2.2.0
microsoft.aspnetcore.http.features@2.3.0
microsoft.aspnetcore.http@2.1.1
microsoft.aspnetcore.http@2.1.22
microsoft.aspnetcore.http@2.2.2
microsoft.aspnetcore.http@2.3.0
microsoft.aspnetcore.jsonpatch@10.0.0
microsoft.aspnetcore.jsonpatch@2.3.0
microsoft.aspnetcore.localization@2.2.0
microsoft.aspnetcore.mvc.abstractions@2.3.0
microsoft.aspnetcore.mvc.analyzers@2.2.0
microsoft.aspnetcore.mvc.apiexplorer@2.2.0
microsoft.aspnetcore.mvc.core@2.2.0
microsoft.aspnetcore.mvc.core@2.3.0
microsoft.aspnetcore.mvc.cors@2.2.0
microsoft.aspnetcore.mvc.dataannotations@2.2.0
microsoft.aspnetcore.mvc.formatters.json@2.2.0
microsoft.aspnetcore.mvc.formatters.json@2.3.0
microsoft.aspnetcore.mvc.localization@2.2.0
microsoft.aspnetcore.mvc.newtonsoftjson@10.0.0
microsoft.aspnetcore.mvc.razor.extensions@2.2.0
microsoft.aspnetcore.mvc.razor@2.2.0
microsoft.aspnetcore.mvc.razorpages@2.2.0
microsoft.aspnetcore.mvc.taghelpers@2.2.0
microsoft.aspnetcore.mvc.viewfeatures@2.2.0
microsoft.aspnetcore.mvc.webapicompatshim@2.3.0
microsoft.aspnetcore.mvc@2.2.0
microsoft.aspnetcore.razor.design@2.2.0
microsoft.aspnetcore.razor.language@2.2.0
microsoft.aspnetcore.razor.runtime@2.2.0
microsoft.aspnetcore.razor@2.2.0
microsoft.aspnetcore.responsecaching.abstractions@2.3.0
microsoft.aspnetcore.routing.abstractions@2.2.0
microsoft.aspnetcore.routing.abstractions@2.3.0
microsoft.aspnetcore.routing@2.3.0
microsoft.aspnetcore.webutilities@2.1.1
microsoft.aspnetcore.webutilities@2.2.0
microsoft.aspnetcore.webutilities@2.3.0
microsoft.azure.appservice.middleware.functions@1.5.11
microsoft.azure.appservice.middleware.modules@1.5.11
microsoft.azure.appservice.middleware.netcore@1.5.11
microsoft.azure.appservice.middleware@1.5.11
microsoft.azure.appservice.proxy.client@2.3.20240307.67
microsoft.azure.appservice.proxy.common@2.3.20240307.67
microsoft.azure.appservice.proxy.runtime@2.3.20240307.67
microsoft.azure.durabletask.azurestorage.internal@1.4.0
microsoft.azure.durabletask.core.internal@2.0.11
microsoft.azure.functions.dotnetisolatednativehost@1.0.15
microsoft.azure.functions.javaworker@2.19.5
microsoft.azure.functions.nodejsworker@3.16.0
microsoft.azure.functions.platform.metrics.linuxconsumption@1.0.5
microsoft.azure.functions.powershellworker.ps7.0@4.0.3148
microsoft.azure.functions.powershellworker.ps7.2@4.0.4025
microsoft.azure.functions.powershellworker.ps7.4@4.0.5361
microsoft.azure.functions.powershellworker.ps7.6@4.0.5362
microsoft.azure.functions.pythonworker@4.46.0
microsoft.azure.functions.worker.itemtemplates@4.0.5708
microsoft.azure.functions.worker.projecttemplates@4.0.5708
microsoft.azure.webjobs.core@3.0.46
microsoft.azure.webjobs.extensions.http@3.3.0
microsoft.azure.webjobs.extensions.timers.storage@1.0.0-beta.1
microsoft.azure.webjobs.extensions@5.0.0-beta.1
microsoft.azure.webjobs.extensions@5.2.1
microsoft.azure.webjobs.host.storage@5.0.0-beta.1
microsoft.azure.webjobs.host.storage@5.0.2
microsoft.azure.webjobs.itemtemplates@4.0.5708
microsoft.azure.webjobs.logging.applicationinsights@3.0.45
microsoft.azure.webjobs.projecttemplates@4.0.5708
microsoft.azure.webjobs.rpc.core@3.0.45
microsoft.azure.webjobs.script.abstractions@1.1.0
microsoft.azure.webjobs.script.grpc@4.1054.250
microsoft.azure.webjobs.script.webhost@4.1054.250
microsoft.azure.webjobs.script@4.1054.250
microsoft.azure.webjobs@3.0.42
microsoft.azure.webjobs@3.0.43
microsoft.azure.webjobs@3.0.44
microsoft.azure.webjobs@3.0.45
microsoft.azure.webjobs@3.0.46
microsoft.azure.websites.dataprotection@2.1.91-alpha
microsoft.bcl.asyncinterfaces@8.0.0
microsoft.build.framework@18.7.1
microsoft.build@18.7.1
microsoft.codeanalysis.analyzers@2.9.4
microsoft.codeanalysis.common@2.8.0
microsoft.codeanalysis.common@3.3.1
microsoft.codeanalysis.csharp.scripting@3.3.1
microsoft.codeanalysis.csharp@2.8.0
microsoft.codeanalysis.csharp@3.3.1
microsoft.codeanalysis.razor@2.2.0
microsoft.codeanalysis.scripting.common@3.3.1
microsoft.extensions.azure@1.13.1
microsoft.extensions.azure@1.7.5
microsoft.extensions.caching.abstractions@10.0.3
microsoft.extensions.caching.abstractions@5.0.0
microsoft.extensions.caching.memory@1.0.0
microsoft.extensions.caching.memory@2.2.0
microsoft.extensions.caching.memory@5.0.0
microsoft.extensions.compliance.abstractions@9.8.0
microsoft.extensions.configuration.abstractions@10.0.0
microsoft.extensions.configuration.abstractions@10.0.9
microsoft.extensions.configuration.abstractions@2.0.0
microsoft.extensions.configuration.abstractions@2.1.1
microsoft.extensions.configuration.abstractions@2.2.0
microsoft.extensions.configuration.abstractions@8.0.0
microsoft.extensions.configuration.binder@10.0.0
microsoft.extensions.configuration.binder@8.0.2
microsoft.extensions.configuration.environmentvariables@2.1.0
microsoft.extensions.configuration.environmentvariables@2.1.1
microsoft.extensions.configuration.fileextensions@2.1.1
microsoft.extensions.configuration.fileextensions@3.1.0
microsoft.extensions.configuration.json@2.1.0
microsoft.extensions.configuration.json@3.1.0
microsoft.extensions.configuration@10.0.0
microsoft.extensions.configuration@2.0.0
microsoft.extensions.configuration@2.1.0
microsoft.extensions.configuration@2.1.1
microsoft.extensions.configuration@3.1.0
microsoft.extensions.configuration@5.0.0
microsoft.extensions.configuration@8.0.0
microsoft.extensions.dependencyinjection.abstractions@10.0.0
microsoft.extensions.dependencyinjection.abstractions@10.0.11
microsoft.extensions.dependencyinjection.abstractions@10.0.9
microsoft.extensions.dependencyinjection.abstractions@2.2.0
microsoft.extensions.dependencyinjection.abstractions@5.0.0
microsoft.extensions.dependencyinjection.abstractions@8.0.2
microsoft.extensions.dependencyinjection.abstractions@9.0.8
microsoft.extensions.dependencyinjection@10.0.11
microsoft.extensions.dependencymodel@10.0.0
microsoft.extensions.dependencymodel@2.1.0
microsoft.extensions.diagnostics.abstractions@10.0.0
microsoft.extensions.diagnostics.abstractions@10.0.9
microsoft.extensions.diagnostics.healthchecks.abstractions@8.0.11
microsoft.extensions.diagnostics.healthchecks@8.0.11
microsoft.extensions.diagnostics@10.0.0
microsoft.extensions.fileproviders.abstractions@10.0.9
microsoft.extensions.fileproviders.abstractions@2.1.0
microsoft.extensions.fileproviders.abstractions@2.1.1
microsoft.extensions.fileproviders.abstractions@2.2.0
microsoft.extensions.fileproviders.abstractions@3.1.0
microsoft.extensions.fileproviders.abstractions@8.0.0
microsoft.extensions.fileproviders.composite@2.2.0
microsoft.extensions.fileproviders.physical@2.1.0
microsoft.extensions.fileproviders.physical@2.1.1
microsoft.extensions.fileproviders.physical@3.1.0
microsoft.extensions.filesystemglobbing@2.1.0
microsoft.extensions.filesystemglobbing@2.1.1
microsoft.extensions.filesystemglobbing@2.2.0
microsoft.extensions.filesystemglobbing@3.1.0
microsoft.extensions.hosting.abstractions@10.0.0
microsoft.extensions.hosting.abstractions@10.0.3
microsoft.extensions.hosting.abstractions@10.0.9
microsoft.extensions.hosting.abstractions@2.1.0
microsoft.extensions.hosting.abstractions@2.1.1
microsoft.extensions.hosting.abstractions@8.0.1
microsoft.extensions.hosting@2.1.0
microsoft.extensions.http.polly@10.0.0
microsoft.extensions.http@10.0.0
microsoft.extensions.http@3.0.3
microsoft.extensions.localization.abstractions@2.2.0
microsoft.extensions.localization@2.2.0
microsoft.extensions.logging.abstractions@10.0.9
microsoft.extensions.logging.applicationinsights@2.23.0
microsoft.extensions.logging.configuration@10.0.0
microsoft.extensions.logging.configuration@2.1.0
microsoft.extensions.logging.console@2.0.0
microsoft.extensions.logging@10.0.9
microsoft.extensions.objectpool@2.1.1
microsoft.extensions.objectpool@2.2.0
microsoft.extensions.objectpool@8.0.11
microsoft.extensions.objectpool@9.0.8
microsoft.extensions.options.configurationextensions@10.0.0
microsoft.extensions.options@10.0.0
microsoft.extensions.options@10.0.9
microsoft.extensions.options@2.1.1
microsoft.extensions.options@2.2.0
microsoft.extensions.options@5.0.0
microsoft.extensions.options@8.0.2
microsoft.extensions.options@9.0.8
microsoft.extensions.primitives@10.0.0
microsoft.extensions.primitives@10.0.3
microsoft.extensions.primitives@10.0.9
microsoft.extensions.primitives@2.2.0
microsoft.extensions.primitives@5.0.0
microsoft.extensions.primitives@8.0.0
microsoft.extensions.telemetry.abstractions@9.8.0
microsoft.extensions.webencoders@2.2.0
microsoft.identity.client.extensions.msal@4.78.0
microsoft.identity.client@4.84.2
microsoft.identitymodel.abstractions@8.14.0
microsoft.identitymodel.abstractions@8.15.0
microsoft.identitymodel.jsonwebtokens@8.15.0
microsoft.identitymodel.logging@8.15.0
microsoft.identitymodel.protocols.openidconnect@6.32.0
microsoft.identitymodel.protocols.openidconnect@8.0.1
microsoft.identitymodel.protocols.openidconnect@8.15.0
microsoft.identitymodel.protocols@6.32.0
microsoft.identitymodel.protocols@8.15.0
microsoft.identitymodel.tokens@6.32.0
microsoft.identitymodel.tokens@8.15.0
microsoft.identitymodel.validators@6.32.0
microsoft.net.http.headers@2.1.1
microsoft.net.http.headers@2.3.0
microsoft.net.stringtools@18.7.1
microsoft.netcore.platforms@1.1.0
microsoft.netcore.platforms@2.0.0
microsoft.security.utilities.core@1.21.0
microsoft.win32.systemevents@8.0.0
mono.posix.netstandard@1.0.0
ncrontab.signed@3.3.3
netstandard.library@1.6.1
newtonsoft.json.bson@1.0.1
newtonsoft.json.bson@1.0.2
newtonsoft.json@13.0.4
nuget.common@5.11.7
nuget.configuration@5.11.7
nuget.dependencyresolver.core@5.11.7
nuget.frameworks@5.11.7
nuget.librarymodel@5.11.7
nuget.packaging@5.11.7
nuget.projectmodel@5.11.7
nuget.protocol@5.11.7
nuget.versioning@5.11.7
opentelemetry.api.providerbuilderextensions@1.14.0
opentelemetry.api.providerbuilderextensions@1.15.3
opentelemetry.api@1.15.3
opentelemetry.api@1.9.0
opentelemetry.exporter.opentelemetryprotocol@1.15.3
opentelemetry.extensions.hosting@1.14.0
opentelemetry.extensions.hosting@1.15.3
opentelemetry.instrumentation.aspnetcore@1.15.2
opentelemetry.instrumentation.http@1.15.1
opentelemetry.instrumentation.process@0.5.0-beta.7
opentelemetry.instrumentation.runtime@1.15.1
opentelemetry.persistentstorage.abstractions@1.0.2
opentelemetry.persistentstorage.filesystem@1.0.2
opentelemetry@1.14.0
opentelemetry@1.15.3
polly.extensions.http@3.0.0
polly@7.1.0
polly@7.2.4
protobuf-net@2.3.3
stylecop.analyzers.unstable@1.2.0.556
stylecop.analyzers@1.2.0-beta.556
system.clientmodel@1.8.0
system.componentmodel.annotations@4.4.0
system.componentmodel.annotations@4.5.0
system.configuration.configurationmanager@10.0.4
system.configuration.configurationmanager@4.5.0
system.configuration.configurationmanager@6.0.0
system.diagnostics.eventlog@10.0.4
system.diagnostics.performancecounter@4.5.0
system.diagnostics.performancecounter@6.0.0
system.drawing.common@8.0.0
system.identitymodel.tokens.jwt@5.1.4
system.identitymodel.tokens.jwt@6.32.0
system.identitymodel.tokens.jwt@8.15.0
system.io.abstractions@2.1.0.227
system.io.filesystem.accesscontrol@4.5.0
system.io.filesystem.accesscontrol@4.7.0
system.io.filesystem.accesscontrol@5.0.0
system.io.hashing@7.0.0
system.io.hashing@8.0.0
system.memory.data@1.0.2
system.memory.data@8.0.1
system.reactive.core@5.0.0
system.reactive.linq@3.1.1
system.reactive.linq@5.0.0
system.reactive@5.0.0
system.reflection.metadataloadcontext@10.0.4
system.security.cryptography.pkcs@10.0.9
system.security.cryptography.pkcs@5.0.0
system.security.cryptography.protecteddata@10.0.4
system.security.cryptography.protecteddata@4.4.0
system.security.cryptography.protecteddata@4.5.0
system.security.cryptography.xml@10.0.9
system.security.cryptography.xml@4.7.1
windowsazure.storage@9.3.3
yamldotnet@18.1.0
yarp.reverseproxy@2.0.1
"

TEMPLATES_JSON_VERSION="3.1.1648"

inherit dotnet-pkg

DESCRIPTION="Command line tools for Azure Functions"
HOMEPAGE="https://github.com/Azure/azure-functions-core-tools"

SRC_URI="
	https://github.com/Azure/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://cdn.functions.azure.com/public/TemplatesApi/${TEMPLATES_JSON_VERSION}.zip -> dotnet-templates-${TEMPLATES_JSON_VERSION}.zip
	${NUGET_URIS}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+python"

BDEPEND="${BDEPEND}
	dev-lang/go"
DEPEND="${RDEPEND}"
PDEPEND="python? (
		dev-python/azure-functions-python-worker
	)
"

DOTNET_PKG_PROJECTS=(
	src/Cli/func/Azure.Functions.Cli.csproj
)

DOTNET_PKG_BAD_PROJECTS=(
	src/CoreToolsHost/CoreToolsHost.csproj
)

DOTNET_PKG_BUILD_EXTRA_ARGS=(
	-p:NoWorkers="true"
)

pkg_setup() {
	dotnet-pkg_pkg_setup
}

src_prepare() {
        sed -i ./*/*/*.csproj \
                -e "/.*<RuntimeIdentifiers>.*/d" \
                -e "/.*<RuntimeFrameworkVersion>.*/d" \
                || die
        find "${S}" -type f -iname "NuGet.config" -exec rm -v {} + || die

	eapply "${FILESDIR}/python-worker-target-workaround.patch"

	# copy templates
	mkdir -p out/obj/Azure.Functions.Cli/templates-staging
	cp "${DISTDIR}"/dotnet-templates-${TEMPLATES_JSON_VERSION}.zip ${S}/out/obj/Azure.Functions.Cli/templates-staging/templates.zip || die
	addwrite /var/tmp/portage/dev-dotnet/azure-functions-core-tools-4.16.0/homedir/.dotnet/corefx/Runtime/SharedMemory

	dotnet-pkg_src_prepare
}

src_configure() {
        dotnet-pkg_foreach-project dotnet-pkg-base_restore
}

src_compile() {
	dotnet-pkg_src_compile
}

src_install() {
	local dest_root="/usr/lib/${PN}-4"

	dotnet-pkg-base_install "${dest_root}"
	dotnet-pkg-base_dolauncher "${dest_root}/func" func

	rm -r "${D}/${dest_root}"/workers/*
	rm "${D}/${dest_root}"/libMonoPosixHelper.so
}
