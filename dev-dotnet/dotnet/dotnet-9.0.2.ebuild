# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
DOTNET_SRC_DIR="src/native/corehost"
DOTNET_TARGETS=(
	'dotnet'
)

inherit dotnet-runtime

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-dotnet/dotnet-runtime
	dev-dotnet/dotnet-sdk"

src_configure() {
	local mycmakeargs=(
		-DCLI_CMAKE_PKG_RID=$(dotnet-utils_get_pkg_rid)
		-DCLI_CMAKE_FALLBACK_OS=$(dotnet-utils_get_pkg_fallback_rid)
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
	)

	cmake_src_configure
}

src_install() {
	exeinto "/usr/lib/dotnet-sdk"
	doexe "${BUILD_DIR}/dotnet/dotnet"
	dosym -r "/usr/lib/dotnet-sdk/dotnet" "/usr/bin/dotnet"
	dodir /etc/dotnet
	echo "/usr/lib/dotnet-sdk" > "${D}/etc/dotnet/install_location"
}
