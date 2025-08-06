# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_RUNTIME_PV="${PV}"
DOTNET_SRC_DIR="src/native/libs"

inherit dotnet-runtime

DESCRIPTION="The .NET Core native libraries (System.*)"
HOMEPAGE="https://www.microsoft.com/net/core"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=app-crypt/mit-krb5-1.14.2
	>=dev-libs/openssl-1.0.2h-r2
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=net-misc/curl-7.49.0
	>=sys-libs/zlib-1.2.8-r1
"
BDEPEND="
	>=sys-devel/gettext-0.19.7"

PATCHES=(
	"${FILESDIR}/remove-build-type-logic.patch"
)

src_configure() {
	local dest="/usr/lib/dotnet-sdk/shared/Microsoft.NETCore.App/${DOTNET_RUNTIME_PV}"

	local mycmakeargs=(
		-DCMAKE_USE_PTHREADS=0
		-DCMAKE_STATIC_LIB_LINK=0
		-DFEATURE_DISTRO_AGNOSTIC_SSL=1
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DCMAKE_INSTALL_PREFIX="${dest}"
	)

	cmake_src_configure
}
