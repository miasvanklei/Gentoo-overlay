# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SDK="${PN}-${PV}-linux-musl"

DESCRIPTION="The .NET Core SDK"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="
	amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-x64.tar.gz )
	arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-arm64.tar.gz )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="${RDEPEND}
	>=dev-dotnet/dotnet-runtime-$(ver_cut 1-2)
	<dev-dotnet/dotnet-runtime-$(ver_cut 1).$(($(ver_cut 2) + 1))
"

src_install() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	local dest="/usr/lib/${PN}"
	local target="linux-musl-${DARCH}"
	local runtime_pack="packs/Microsoft.NETCore.App.Host.${target}/current/runtimes/${target}/native"

	insinto "${dest}"
	doins -r "${S}"/sdk "${S}"/sdk-manifests "${S}"/templates

	insinto "${dest}/packs"
	doins -r "${S}"/packs/Microsoft.AspNetCore.App.Ref \
		"${S}"/packs/Microsoft.NETCore.App.Ref "${S}"/packs/NETStandard.Library.Ref

	# Create a magic workloads file, bug #841896
	local featureband="$(( $(ver_cut 3) / 100 * 100 ))"       # e.g. 404 -> 400
	local workloads="metadata/workloads/$(ver_cut 1-2).${featureband}"

	mkdir -p "${D}/${dest}/${workloads}" || die
	touch "${D}/${dest}/${workloads}/userlocal" || die

	# link apphost
	dosym "${dest}/${runtime_pack}/apphost" "${dest}/sdk/${PV}/AppHostTemplate/apphost"
}
