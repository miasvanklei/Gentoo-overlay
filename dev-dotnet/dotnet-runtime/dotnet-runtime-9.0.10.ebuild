# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_SRC_DIR="src/coreclr"
DOTNET_TARGETS=(
	'debug/createdump/createdump'
	'dlls/mscordac/libmscordaccore.so'
	'dlls/mscordbi/libmscordbi.so'
	'dlls/mscoree/coreclr/libcoreclr.so'
	'gc/libclrgc.so'
	'gc/libclrgcexp.so'
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

src_prepare() {
	eapply "${FILESDIR}"/fix-and-cleanup-set-stacksize-9.0.patch
	eapply "${FILESDIR}"/fix-missing-invalid-state.patch

	pushd "${S}/../native/libs" >/dev/null || die
	eapply "${FILESDIR}"/remove-native-build-type-logic.patch
	popd >/dev/null || die

	pushd "${S}/../../" >/dev/null || die
	eapply "${FILESDIR}"/remove-coreclr-build-type-logic-9.0.patch
	popd >/dev/null || die

	dotnet-runtime_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCLR_CMAKE_PGO_INSTRUMENT=0
		-DCLR_CMAKE_PGO_OPTIMIZE=0
		-DCLI_CMAKE_FALLBACK_OS="$(dotnet-utils_get_pkg_fallback_rid)"
		-DFEATURE_DISTRO_AGNOSTIC_SSL=1
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF # coreclr assumes precompiled headers
		-DBUILD_SHARED_LIBS=OFF # coreclr assumes that default library target is static
	)

	cmake_src_configure
}
