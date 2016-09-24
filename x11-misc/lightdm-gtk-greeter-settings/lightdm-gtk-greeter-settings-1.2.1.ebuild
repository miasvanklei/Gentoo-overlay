# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(pypy python3_5)

inherit vcs-snapshot distutils-r1

DESCRIPTION="An unofficial api for Google Play Music"
HOMEPAGE="https://github.com/simon-weber/gmusicapi"
SRC_URI="https://launchpad.net/lightdm-gtk-greeter-settings/${PV%.*}/${PV}/+download/lightdm-gtk-greeter-settings-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"
