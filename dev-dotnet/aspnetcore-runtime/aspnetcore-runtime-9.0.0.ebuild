# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
RUNTIME_PACK="Microsoft.AspNetCore.App"
NUGETS=(
	"microsoft.aspnetcore.app.runtime.linux-musl-arm64 arm64"
	"microsoft.aspnetcore.app.runtime.linux-musl-x64 amd64"
)

inherit dotnet-pack

DESCRIPTION="The ASP.NET Core runtime"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	=dev-dotnet/dotnet-runtime-${PV}
"
