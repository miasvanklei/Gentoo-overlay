# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for dotnet core"

SLOT="6"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="
	dev-dotnet/dotnet-sdk
	dev-dotnet/dotnet-runtime
        dev-dotnet/netcore-runtime
        dev-dotnet/aspnet-runtime
"

S=${WORKDIR}
COMMON_PV="${PV/_rc/-rc.}"
ASPNET_PV="${COMMON_PV}.21480.10"
RUNTIME_PV="${COMMON_PV}.21480.5"

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

	create_symlink host/fxr ${RUNTIME_PV}
	create_symlink packs/Microsoft.NETCore.App.Host.linux-musl-${DARCH} ${RUNTIME_PV}
	create_symlink shared/Microsoft.NETCore.App ${RUNTIME_PV}
	create_symlink shared/Microsoft.AspNetCore.App $ASPNET_PV}
}
