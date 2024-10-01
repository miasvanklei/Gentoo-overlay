# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="Proxies sensor devices (accelerometers, light sensors, compass) to applications through D-Bus"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"
EGIT_REPO_URI="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	sys-apps/systemd
	dev-libs/libgudev
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )
