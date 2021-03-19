# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://android.googlesource.com/platform/system/core"
SRC_URI="https://github.com/nmeum/${PN}/releases/download/${PV/_/}/${P/_/}.tar.xz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-lang/go
	dev-lang/perl
	virtual/libusb"

RDEPEND="dev-cpp/gtest"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=0
	)

	cmake_src_configure
}
