# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
DOTNET_SRC_DIR="src/coreclr"
DOTNET_TARGETS=(
	'debug/createdump/createdump'
	'dlls/mscordac/libmscordaccore.so'
	'dlls/mscordbi/libmscordbi.so'
	'dlls/mscoree/coreclr/libcoreclr.so'
	'gc/libclrgc.so'
	'jit/libclrjit.so'
	'pal/src/eventprovider/lttngprovider/libcoreclrtraceptprovider.so'
)
RUNTIME_PACK="Microsoft.NETCore.App"
NUGETS=(
	"microsoft.netcore.app.runtime.linux-musl-arm64 arm64"
	"microsoft.netcore.app.runtime.linux-musl-x64 amd64"
)

inherit dotnet-runtime

DESCRIPTION="The .NET Core runtime"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
        >=dev-libs/openssl-1.0.2h-r2
        >=dev-libs/icu-57.1
        >=dev-util/lttng-ust-2.8.1
	>=sys-devel/gettext-0.19.7"

RDEPEND="
	${BDEPEND}
	=dev-dotnet/dotnet-native-libs-${PV}
	=dev-dotnet/dotnet-apphost-pack-${PV}"

PATCHES=(
	"${FILESDIR}"/fix-missing-definition.patch
	"${FILESDIR}"/fix-and-cleanup-set-stacksize-8.0.patch
)

src_configure() {
	local mycmakeargs=(
		-DCLR_CMAKE_PGO_INSTRUMENT=0
		-DCLR_CMAKE_PGO_OPTIMIZE=0
		-DCLI_CMAKE_FALLBACK_OS="$(get_pkg_rid 0)"
		-DFEATURE_DISTRO_AGNOSTIC_SSL=1
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF # coreclr assumes precompiled headers
		-DBUILD_SHARED_LIBS=OFF # coreclr assumes that default library target is static
	)

	cmake_src_configure
}
