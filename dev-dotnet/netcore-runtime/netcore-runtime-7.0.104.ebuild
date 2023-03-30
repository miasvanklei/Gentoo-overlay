# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SDK="dotnet-sdk-${PV}-linux-musl"

SRC_URI="
        amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-x64.tar.gz )
        arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-arm64.tar.gz )
"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
        local dest_core="usr/share/dotnet/shared/Microsoft.NETCore.App"
	local dest="${D}/${dest_core}"

        mkdir -p "${dest}" || die
        cp -rpP "${S}"/shared/Microsoft.NETCore.App/* ${dest}/current || die

        # delete files installed by dotnet-runtime
        rm ${dest}/current/*.so
        rm ${dest}/current/createdump
}
