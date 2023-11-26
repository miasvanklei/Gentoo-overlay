# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The .NET Core SDK"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SDK="${PN}-${PV}-linux-musl"

SRC_URI="
	amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-x64.tar.gz )
	arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-arm64.tar.gz )
"

SDK_SLOT="$(ver_cut 1-2)"
RUNTIME_SLOT="${SDK_SLOT}.0"
SLOT="${SDK_SLOT}/${RUNTIME_SLOT}"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-dotnet/dotnet-runtime
"

S="${WORKDIR}"

src_install() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	local dest="/usr/share/dotnet"
	local target="linux-musl-${DARCH}"
	local runtime_pack="packs/Microsoft.NETCore.App.Host.${target}/current/runtimes/${target}/native"

	dodir "${dest}"
	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates

	# link apphost
	dosym "${dest}/${runtime_pack}/apphost" "${dest}/sdk/${PV}/AppHostTemplate/apphost"
}
