# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

MY_PV="${PV/_pre/-preview.}.21379.14"
SDK="dotnet-sdk-${MY_PV}-linux-musl"

SRC_URI="
        amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/${SDK}-x64.tar.gz )
        arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/${SDK}-arm64.tar.gz )
"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	if use amd64; then
		eapply "${FILESDIR}"/missing-runtime-x64.patch
	elif use arm64; then
		eapply "${FILESDIR}"/missing-runtime-arm64.patch
	fi

	eapply_user
}

src_install() {
        local dest_core="usr/share/dotnet/shared/Microsoft.NETCore.App"
	local dest="${D}/${dest_core}"

        mkdir -p "${dest}" || die
        cp -rpP "${S}"/shared/Microsoft.NETCore.App/* ${dest}/current || die

        # delete files installed by dotnet-runtime
        rm ${dest}/current/*.so
        rm ${dest}/current/createdump
}
