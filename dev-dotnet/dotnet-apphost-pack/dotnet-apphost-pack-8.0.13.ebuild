# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_COMMIT="eba546b0f0d448e0176a2222548fd7a2fbf464c0"
DOTNET_RUNTIME_PV="${PV}"
DOTNET_SRC_DIR="src/native/corehost"
DOTNET_TARGETS=(
	'libhostpolicy.so'
	'apphost'
	'libnethost.so'
	'libhostfxr.so'
)

inherit dotnet-utils dotnet-runtime

DESCRIPTION="The .NET Core apphost pack"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"

src_configure() {
	local mycmakeargs=(
		-DCLI_CMAKE_PKG_RID=$(dotnet-utils_get_pkg_rid)
		-DCLI_CMAKE_FALLBACK_OS=$(dotnet-utils_get_pkg_fallback_rid)
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DCLI_CMAKE_COMMIT_HASH="${DOTNET_COMMIT:0:10}"
	)

	cmake_src_configure
}

src_install() {
	local dest="usr/lib/dotnet-sdk"
	local target=$(dotnet-utils_get_pkg_rid 1)
	local dest_apphost_pack="${dest}/packs/Microsoft.NETCore.App.Host.${target}/${DOTNET_RUNTIME_PV}/runtimes/${target}/native"
        local dest_netcore_app="${dest}/shared/Microsoft.NETCore.App/${DOTNET_RUNTIME_PV}"
	local dest_fxr="${dest}/host/fxr/${DOTNET_RUNTIME_PV}"

	insinto "${dest_netcore_app}"
	doins "${BUILD_DIR}/hostpolicy/standalone/libhostpolicy.so"
	doins "${BUILD_DIR}/fxr/standalone/libhostfxr.so"

	insinto "${dest_apphost_pack}"
	doins "${BUILD_DIR}/apphost/standalone/apphost"
	doins "${BUILD_DIR}/nethost/libnethost.so"

	insinto "${dest_fxr}"
	doins "${BUILD_DIR}/fxr/standalone/libhostfxr.so"
}
