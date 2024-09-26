# Copyright 2021-2024 Gentoo Authors
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

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-dotnet/dotnet-runtime-$(ver_cut 1-2)
	<dev-dotnet/dotnet-runtime-$(ver_cut 1).$(($(ver_cut 2) + 1))
"

S="${WORKDIR}"

src_install() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	local dest="/usr/lib/${PN}"
	local target="linux-musl-${DARCH}"
	local runtime_pack="packs/Microsoft.NETCore.App.Host.${target}/current/runtimes/${target}/native"

	dodir "${dest}"
	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates
	dodir "${dest}/packs"
	insinto "${dest}/packs"
	doins -r "${S}"/packs/Microsoft.AspNetCore.App.Ref "${S}"/packs/Microsoft.NETCore.App.Ref "${S}"/packs/NETStandard.Library.Ref

	mkdir -p "${D}/${dest}/metadata/workloads/${PV}"
	touch "${D}/${dest}/metadata/workloads/${PV}/userlocal"

	# link apphost
	dosym "${dest}/${runtime_pack}/apphost" "${dest}/sdk/${PV}/AppHostTemplate/apphost"
}
