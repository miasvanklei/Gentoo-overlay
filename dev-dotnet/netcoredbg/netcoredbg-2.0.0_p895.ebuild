# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

RUNTIME_PV="6.0.3"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="https://github.com/Samsung/netcoredbg/archive/${PV/_p/-}.tar.gz -> ${P}.tar.gz
	https://github.com/dotnet/runtime/archive/v${RUNTIME_PV}.tar.gz -> dotnet-runtime-${RUNTIME_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-dotnet/dotnet-runtime"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_p/-}"

PATCHES=(
	"${FILESDIR}"/fix-compile.patch
)

pkg_setup() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
}

src_configure() {
	local mycmakeargs=(
		-DDOTNET_DIR=/usr/share/dotnet
		-DCORECLR_DIR=${WORKDIR}/runtime-${RUNTIME_PV}/src/coreclr
	)

	cmake_src_configure
}

src_install() {
	local install_path=${D}/usr/share/dotnet/shared/Microsoft.NETCore.App/current

	cmake_src_install

	mkdir -p ${install_path} || die
	mv ${D}/usr/*.dll ${install_path} || die
	mv ${D}/usr/netcoredbg ${install_path} || die
	rm ${D}/usr/libdbgshim.so || die

	dosym "${D}/usr/share/dotnet/shared/Microsoft.NETCore.App/current/netcoredbg" "/usr/bin/netcoredbg"
}
