# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
TARGETING_PACK="NETStandard.Library.Ref"
NUGETS=(
	netstandard.library.ref
)

inherit dotnet-pack

DESCRIPTION="The .NET 2.1 Standard targeting pack"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
