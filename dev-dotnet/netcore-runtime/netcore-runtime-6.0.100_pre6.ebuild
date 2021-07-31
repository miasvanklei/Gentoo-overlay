# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

MY_PV="${PV/_pre/-preview.}.21355.2"
SDK="dotnet-sdk-${MY_PV}-linux-musl"

SRC_URI="
        amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/${SDK}-x64.tar.gz )
        arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/${SDK}-arm64.tar.gz )
"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/missing-runtime.patch
)

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