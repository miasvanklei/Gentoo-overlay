# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Efficient, Pythonic bidirectional map implementation and related functionality"
HOMEPAGE="https://bidict.readthedocs.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="
	app-text/poppler[cairo,introspection]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	dev-python/python-vlc[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"

DEPEND="${RDEPEND}"
