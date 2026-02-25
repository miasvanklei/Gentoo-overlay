# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for .NET SDK"

SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	dev-dotnet/dotnet-targeting-pack:"${SLOT}"
	dev-dotnet/aspnetcore-targeting-pack:"${SLOT}"
	dev-dotnet/dotnet-sdk
	dev-dotnet/dotnet"
