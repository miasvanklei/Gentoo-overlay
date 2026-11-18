# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# keep in sync with dotnet-runtime
DOTNET_PV="$(ver_cut 1-3)"
SDK_PV="$(ver_cut 1-2).$(ver_cut 4)"
SDK_RELEASE_SUFFIX="$(ver_cut 5)"
SDK_PV_SUFFIX="$(ver_cut 6-)"
if [[ -n $SDK_RELEASE_SUFFIX ]]; then
        fixed_suffix="${SDK_RELEASE_SUFFIX//pre/preview}"
        SDK_FULL_PV="${SDK_PV}-${fixed_suffix}.${SDK_PV_SUFFIX:0:1}.${SDK_PV_SUFFIX:1:5}.${SDK_PV_SUFFIX:6:3}"
	DOTNET_SDK_RUNTIME_PV="${DOTNET_PV}-${fixed_suffix}.${SDK_PV_SUFFIX:0:1}.${SDK_PV_SUFFIX:1:5}.${SDK_PV_SUFFIX:6:3}"
        DOTNET_RUNTIME_PV="${DOTNET_PV}_${SDK_RELEASE_SUFFIX}${SDK_PV_SUFFIX}"
else
	SDK_FULL_PV="${SDK_PV}"
        DOTNET_SDK_RUNTIME_PV="${DOTNET_PV}"
        DOTNET_RUNTIME_PV="${DOTNET_PV}"
fi

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

QA_PRESTRIPPED="
	/usr/lib/dotnet-sdk/sdk/${SDK_FULL_PV}/AppHostTemplate/apphost
	/usr/lib/dotnet-sdk/sdk/${SDK_FULL_PV}/Roslyn/bincore/VBCSCompiler
	/usr/lib/dotnet-sdk/sdk/${SDK_FULL_PV}/Roslyn/bincore/csc
	/usr/lib/dotnet-sdk/sdk/${SDK_FULL_PV}/Roslyn/bincore/vbc
	/usr/lib/dotnet-sdk/sdk/${SDK_FULL_PV}/MSBuild
"

replace_bin()  {
	${FILESDIR}/create-apphost -t $1 -d $2.dll -o $2
}

src_install() {
	local dest="/usr/lib/${PN}"
	local target=$(dotnet-utils_get_pkg_rid 1)
	local dest_apphost_pack="${dest}/packs/Microsoft.NETCore.App.Host.${target}/${DOTNET_SDK_RUNTIME_PV}/runtimes/${target}/native"

	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 4) / 100 * 100 ))"
	local workloads="metadata/workloads/$(ver_cut 1-2).${featureband}"

	mkdir -p "${D}/${dest}/${workloads}" || die
	touch "${D}/${dest}/${workloads}/userlocal" || die

	cp "${dest_apphost_pack}/apphost"  "${D}/${dest}/sdk/${SDK_FULL_PV}/AppHostTemplate/apphost" || die

	pushd "${D}/${dest}/sdk/${SDK_FULL_PV}/Roslyn/bincore" >/dev/null || die
	replace_bin "${dest_apphost_pack}/apphost" csc
	replace_bin "${dest_apphost_pack}/apphost" vbc
	replace_bin "${dest_apphost_pack}/apphost" VBCSCompiler
	popd >/dev/null || die

	pushd "${D}/${dest}/sdk/${SDK_FULL_PV}" >/dev/null || die
	replace_bin "${dest_apphost_pack}/apphost" MSBuild
	popd >/dev/null || die

	# dev-dotnet/aspnetcoretools
	rm -r "${D}/${dest}/sdk/${SDK_FULL_PV}/DotnetTools/aspnetcoretools" || die
}
