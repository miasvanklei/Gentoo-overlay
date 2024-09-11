# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

RUNTIME_PV="8.0.8"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="https://github.com/Samsung/netcoredbg/archive/refs/tags/${PV/_p/-}.tar.gz -> ${P}.tar.gz
	https://github.com/dotnet/runtime/archive/v${RUNTIME_PV}.tar.gz -> dotnet-runtime-${RUNTIME_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

RDEPEND="
	dev-dotnet/diagnostics
	virtual/dotnet-core"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_p/-}"

PATCHES=(
	"${FILESDIR}"/fix-compile.patch
)

INSTALL_PATH="/usr/share/dotnet/shared/Microsoft.NETCore.App/current"

pkg_setup() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
}

src_configure() {
	local mycmakeargs=(
		-DDOTNET_DIR=/usr/share/dotnet
		-DCORECLR_DIR=${WORKDIR}/runtime-${RUNTIME_PV}/src/coreclr
		-DDBGSHIM_DIR="${INSTALL_PATH}"
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PATH}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym "${INSTALL_PATH}/netcoredbg" "/usr/bin/netcoredbg"
	echo '/usr/bin/netcoredbg --interpreter=vscode "$@"' > "${D}"/usr/bin/vsdbg-ui
	fperms +x /usr/bin/vsdbg-ui
}
