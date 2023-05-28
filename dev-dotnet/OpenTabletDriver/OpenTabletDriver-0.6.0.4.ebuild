# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Open source, cross-platform, user-mode tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver/OpenTabletDriver"
LICENSE="LGPL-3"

SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RDEPEND="virtual/dotnet-core"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/improve-sleep-detection.patch
)

src_compile() {
	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1

	./build.sh linux-musl-x64 || die

	./generate-rules.sh || die
}

src_install() {
	insinto /usr/share/${PN}
	doins bin/*.dll bin/*.json bin/*.pdb

	insinto /usr/lib/udev/rules.d
	doins bin/99-${PN,,}.rules

	insinto /usr/share/pixmaps
	doins ${PN}.UX/Assets/otd.png

	dobin ${FILESDIR}/otd ${FILESDIR}/otd-gui

	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop

	systemd_douserunit ${FILESDIR}/${PN,,}.service
}
