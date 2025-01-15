# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
TARGETING_PACK="Microsoft.NETCore.App.Ref"
NUGETS=(
	"microsoft.netcore.app.ref"
)

inherit dotnet-pack

DESCRIPTION="The .NET Core targeting pack"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
