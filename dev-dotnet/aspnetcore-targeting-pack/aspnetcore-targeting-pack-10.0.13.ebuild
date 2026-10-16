# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TARGETING_PACK="Microsoft.AspNetCore.App.Ref"
NUGETS=(
	"microsoft.aspnetcore.app.ref"
)

inherit dotnet-pack

DESCRIPTION="The ASP.NET Core targeting pack"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
