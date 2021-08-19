# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for dotnet core"

SLOT="5"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="
	dev-dotnet/dotnet-sdk
	dev-dotnet/dotnet-runtime
        dev-dotnet/netcore-runtime
        dev-dotnet/aspnet-runtime
"

S=${WORKDIR}

create_symlink() {
	mkdir -p $1
	pushd $1 >/dev/null
	ln -s current $2
	popd >/dev/null
}

src_install() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	mkdir -p ${D}/usr/share/dotnet
	cd ${D}/usr/share/dotnet

	create_symlink host/fxr ${PV}
	create_symlink packs/Microsoft.NETCore.App.Host.linux-musl-${DARCH} ${PV}
	create_symlink shared/Microsoft.NETCore.App ${PV}
	create_symlink shared/Microsoft.AspNetCore.App ${PV}
	create_symlink sdk 5.0.102
}
