# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# keep in sync with dotnet-runtime
DOTNET_RUNTIME_PV="${PV/200/2}"
REAL_PV="${PV}"
SDK="${PN}-${REAL_PV}-linux-musl"

DESCRIPTION="The .NET Core SDK"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="
	amd64? ( "https://dotnetcli.azureedge.net/dotnet/Sdk/${REAL_PV}/${SDK}-x64.tar.gz" )
	arm64? ( "https://dotnetcli.azureedge.net/dotnet/Sdk/${REAL_PV}/${SDK}-arm64.tar.gz" )
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

	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))"
	local workloads="metadata/workloads/$(ver_cut 1-2).${featureband}"

	mkdir -p "${D}/${dest}/${workloads}" || die
	touch "${D}/${dest}/${workloads}/userlocal" || die

	rm "${D}/${dest}/sdk/${REAL_PV}/AppHostTemplate/apphost" || die
}
