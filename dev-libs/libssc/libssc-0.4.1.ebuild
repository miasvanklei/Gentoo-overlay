# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Library for exposing Qualcomm Sensor Core sensors to Linux"
HOMEPAGE="https://https://libssc.dylanvanassche.be/"
SRC_URI="https://codeberg.org/DylanVanAssche/libssc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
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

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/dont-install-mock-tests.patch
	"${FILESDIR}"/fix-use-after-free.patch
)
