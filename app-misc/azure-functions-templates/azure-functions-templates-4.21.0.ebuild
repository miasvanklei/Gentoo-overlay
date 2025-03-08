# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=9.0
inherit dotnet-pkg-base

DESCRIPTION="Azure functions templates for the azure portal, CLI, and VS"
HOMEPAGE="https://github.com/Azure/azure-functions-templates"
SRC_URI="
	https://github.com/Azure/azure-functions-templates/archive/refs/tags/Bundle.Preview-${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

S="${WORKDIR}/${PN}-Bundle.Preview-${PV}"

TEMPLATE_VERSION="4.0.1"

src_prepare() {
	# dummy csproj needed for dotnet pack
	cp "${FILESDIR}/dummy.csproj" "${S}/Build"

	# be able to generate template.json
	cp "${FILESDIR}/create-template.js" "${S}/Build"

	# Fix directories (case-sensitive)
	mv Functions.Templates/Templates Functions.Templates/templates || die
	sed -i -e 's|\\Templates\\|\\templates\\|g' Build/PackageFiles/Dotnet_precompiled/ItemTemplates-Isolated_v4.x.nuspec || die
	sed -i -e 's|\\Templates\\|\\templates\\|g' Build/PackageFiles/Dotnet_precompiled/ItemTemplates_v4.x.nuspec || die

	dotnet-pkg-base_setup

	eapply_user
}

src_compile() {
	local nuspec_files=(
		PackageFiles/Dotnet_precompiled/ProjectTemplates-Isolated_v4.x.nuspec
		PackageFiles/Dotnet_precompiled/ProjectTemplates_v4.x.nuspec
		PackageFiles/Dotnet_precompiled/ItemTemplates-Isolated_v4.x.nuspec
		PackageFiles/Dotnet_precompiled/ItemTemplates_v4.x.nuspec
	)

	pushd Build >/dev/null

	# Build Project/ItemTemplates, ExtensionBundleTemplates
	edotnet build
	for i in ${nuspec_files[@]}; do
		edotnet pack -p:NuspecFile=$i --no-build --output ../bin/Temp/Dotnet_precompiled/ || die
	done
	edotnet pack -p:NuspecFile=PackageFiles/ExtensionBundle/ExtensionBundleTemplates-4.x.nuspec --no-build --output ../bin/Temp/ExtensionBundle || die

	# Create template.json
	unzip -qq ../bin/Temp/ExtensionBundle/ExtensionBundle.v4.Templates.${TEMPLATE_VERSION}.nupkg -d ../bin/Temp/Temp-ExtensionBundle.v4.Templates.${TEMPLATE_VERSION} || die
	mkdir -p ../bin/Temp/out/ExtensionBundle.v4.Templates.${TEMPLATE_VERSION}/templates || die
	node create-template.js >/dev/null || die

	popd >/dev/null
}

src_install() {
	insinto /usr/lib/azure-functions-core-tools-4/templates/net-isolated
	newins bin/Temp/Dotnet_precompiled/Microsoft.Azure.Functions.Worker.ItemTemplates.${TEMPLATE_VERSION}.nupkg itemTemplates.${TEMPLATE_VERSION}.nupkg
	newins bin/Temp/Dotnet_precompiled/Microsoft.Azure.Functions.Worker.ProjectTemplates.${TEMPLATE_VERSION}.nupkg projectTemplates.${TEMPLATE_VERSION}.nupkg

	insinto /usr/lib/azure-functions-core-tools-4/templates
	newins bin/Temp/Dotnet_precompiled/Microsoft.Azure.WebJobs.ItemTemplates.${TEMPLATE_VERSION}.nupkg itemTemplates.${TEMPLATE_VERSION}.nupkg
	newins bin/Temp/Dotnet_precompiled/Microsoft.Azure.WebJobs.ProjectTemplates.${TEMPLATE_VERSION}.nupkg projectTemplates.${TEMPLATE_VERSION}.nupkg

	insinto /usr/lib/azure-functions-core-tools-4/templates
	doins bin/Temp/out/ExtensionBundle.v4.Templates.${TEMPLATE_VERSION}/templates/templates.json
}
