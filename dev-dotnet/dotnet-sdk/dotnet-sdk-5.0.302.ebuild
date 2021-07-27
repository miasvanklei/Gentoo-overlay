# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SDK="${PN}-${PV}-linux-musl"

SRC_URI="
        amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-x64.tar.gz )
        arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/${SDK}-arm64.tar.gz )
"

SLOT="5"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	rm "${S}/sdk/${PV}/AppHostTemplate/apphost" || die

	default
}

src_install() {
        local dest_core="usr/share/dotnet"
	local dest="${D}/${dest_core}/sdk"

	mkdir -p "${dest}" || die
	cp -rpP "${S}"/sdk/* ${dest} || die
}
