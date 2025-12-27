# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# keep in sync with dotnet-runtime
SDK_PV="$(ver_cut 1-3)"
SDK_PV_SUFFIX="$(ver_cut 4-)"
if [[ -n $SDK_PV_SUFFIX ]]; then
        SDK_FULL_PV="${SDK_PV}-rc.${SDK_PV_SUFFIX:2:1}.${SDK_PV_SUFFIX:3:5}.${SDK_PV_SUFFIX:8:3}"
else
	SDK_FULL_PV="${SDK_PV}"
fi

DOTNET_RUNTIME_PV="${PV/.101/.1}"
SDK="${PN}-${SDK_FULL_PV}-linux-musl"

inherit dotnet-utils

DESCRIPTION="The .NET Core SDK"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="
	amd64? ( "https://builds.dotnet.microsoft.com/dotnet/Sdk/${SDK_FULL_PV}/${SDK}-x64.tar.gz" )
	arm64? ( "https://builds.dotnet.microsoft.com/dotnet/Sdk/${SDK_FULL_PV}/${SDK}-arm64.tar.gz" )
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

replace_bin()  {
	echo -e '#!/bin/bash\ndotnet $0.dll "$@"' > $1
	chmod +x $1
}

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

	cp "${dest_apphost_pack}/apphost"  "${D}/${dest}/sdk/${SDK_FULL_PV}/AppHostTemplate/apphost" || die

	pushd "${D}/${dest}/sdk/${SDK_FULL_PV}/Roslyn/bincore" >/dev/null || die
	replace_bin csc
	replace_bin vbc
	replace_bin VBCSCompiler
	popd >/dev/null || die
}
