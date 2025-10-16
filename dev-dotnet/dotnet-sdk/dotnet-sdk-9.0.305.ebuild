# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# keep in sync with dotnet-runtime
DOTNET_RUNTIME_PV="9.0.9"
SDK="${PN}-${PV}-linux-musl"

inherit dotnet-utils

DESCRIPTION="The .NET Core SDK"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="
	amd64? ( "https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-x64.tar.gz" )
	arm64? ( "https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-arm64.tar.gz" )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	=dev-dotnet/aspnetcore-runtime-"${DOTNET_RUNTIME_PV}"
	=dev-dotnet/aspnetcore-targeting-pack-"${DOTNET_RUNTIME_PV}"
	=dev-dotnet/dotnet-apphost-pack-"${DOTNET_RUNTIME_PV}"
	=dev-dotnet/dotnet-runtime-"${DOTNET_RUNTIME_PV}"
	=dev-dotnet/dotnet-targeting-pack-"${DOTNET_RUNTIME_PV}"
	>=dev-dotnet/netstandard-targeting-pack-2.1.0
"

PDEPEND="virtual/dotnet-sdk:$(ver_cut 1-2)"

src_install() {
	local dest="/usr/lib/${PN}"
	local target=$(dotnet-utils_get_pkg_rid 1)
	local dest_apphost_pack="${dest}/packs/Microsoft.NETCore.App.Host.${target}/${DOTNET_RUNTIME_PV}/runtimes/${target}/native"

	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))"
	local workloads="metadata/workloads/$(ver_cut 1-2).${featureband}"

	mkdir -p "${D}/${dest}/${workloads}" || die
	touch "${D}/${dest}/${workloads}/userlocal" || die

	cp "${dest_apphost_pack}/apphost"  "${D}/${dest}/sdk/${PV}/AppHostTemplate/apphost" || die
}
