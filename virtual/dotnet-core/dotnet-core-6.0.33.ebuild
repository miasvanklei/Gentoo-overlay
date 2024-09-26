# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for dotnet core"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="
	dev-dotnet/dotnet-runtime
	|| (
		~dev-dotnet/dotnet-runtime-nugets-${PV}
		(
			>=dev-dotnet/dotnet-runtime-${PV}
			<dev-dotnet/dotnet-runtime-$(ver_cut 1).$(($(ver_cut 2) + 1))
		)
	)
"

S=${WORKDIR}

create_symlink() {
	dosym current /usr/lib/dotnet-sdk/$1/${PV}
}

src_install() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	mkdir -p ${D}/usr/lib/dotnet-sdk

	create_symlink host/fxr
	create_symlink packs/Microsoft.NETCore.App.Host.linux-musl-${DARCH}
	create_symlink shared/Microsoft.NETCore.App
	create_symlink shared/Microsoft.AspNetCore.App

	dosym dotnet-sdk /usr/lib/dotnet-sdk-$(ver_cut 1-2)
}
