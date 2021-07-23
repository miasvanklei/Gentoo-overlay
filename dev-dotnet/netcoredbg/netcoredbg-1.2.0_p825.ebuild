# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

RPV="5.0.7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
SRC_URI="https://github.com/Samsung/netcoredbg/archive/${PV/_p/-}.tar.gz -> ${P}.tar.gz
	https://github.com/dotnet/runtime/archive/v${RPV}.tar.gz -> dotnet-core-${RPV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-dotnet/dotnet-core"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="/usr/share/dotnet/libdbgshim.so"

S="${WORKDIR}/${P/_p/-}"

pkg_setup() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
}

src_prepare() {
	pushd ${WORKDIR}/runtime-${RPV} >/dev/null
	eapply "${FILESDIR}/fix-shared-profiling-header.patch"
	popd >/dev/null

	cmake_src_prepare
}

src_configure()
{
	local mycmakeargs=(
		-DDOTNET_DIR=/usr/share/dotnet
		-DCORECLR_DIR=${WORKDIR}/runtime-${RPV}/src/coreclr
	)

	cmake_src_configure
}

src_install()
{
	cmake_src_install
	mv ${D}/usr ${D}/temp || die
	mkdir -p ${D}/usr/share || die
	mv ${D}/temp ${D}/usr/share/dotnet || die
	dosym "${D}/usr/share/dotnet/netcoredbg" "/usr/bin/netcoredbg"
}
