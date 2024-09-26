# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for .NET SDK"

SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	>=dev-dotnet/dotnet-sdk-${PV}
	<dev-dotnet/dotnet-sdk-$(ver_cut 1).$(($(ver_cut 2) + 1))
"
