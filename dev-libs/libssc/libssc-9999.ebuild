# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="Library for exposing Qualcomm Sensor Core sensors to Linux"
HOMEPAGE="https://libssc.dylanvanassche.be/"
EGIT_REPO_URI="https://codeberg.org/DylanVanAssche/libssc.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+introspection"

RDEPEND="
"
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-libs/protobuf-c
	net-libs/libqmi[introspection]
"

PATCHES=(
	"${FILESDIR}"/dont-install-mock-tests.patch
)
