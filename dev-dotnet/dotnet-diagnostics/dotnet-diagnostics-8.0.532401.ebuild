# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"

SRC_URI="https://github.com/dotnet/diagnostics/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/diagnostics-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}/fix-build.patch"
)

src_prepare() {
	# disable prerelease (Werror etc)
	sed -i '/set(PRERELEASE 1)/d' eng/native/configureplatform.cmake || die

	# prepare version file
	mkdir -p artifacts/obj
	./eng/native/version/copy_version_files.sh

	cmake_src_prepare
}

src_configure() {
	INSTALL_PREFIX="/usr/$(get_libdir)/${PN}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=ON
		-DCMAKE_SKIP_RPATH=TRUE
	)

	cmake_src_configure
}
