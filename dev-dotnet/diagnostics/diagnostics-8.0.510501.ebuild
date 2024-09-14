# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

inherit toolchain-funcs cmake

SRC_URI="https://github.com/dotnet/diagnostics/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}/fix-build.patch"
)

src_prepare() {
	sed -i '/set(PRERELEASE 1)/d' eng/native/configureplatform.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=ON
		-DCMAKE_SKIP_RPATH=TRUE
	)

	cmake_src_configure
}

src_install() {
	insinto /usr/share/dotnet/shared/Microsoft.NETCore.App/current
	doins "${BUILD_DIR}/src/dbgshim/libdbgshim.so"
}
