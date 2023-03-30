# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Efficient, Pythonic bidirectional map implementation and related functionality"
HOMEPAGE="https://bidict.readthedocs.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="gstreamer vlc"

BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]"

RDEPEND="
	app-text/poppler[cairo,introspection]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	vlc? ( dev-python/python-vlc[${PYTHON_USEDEP}] )
	gstreamer? ( dev-python/gst-python[${PYTHON_USEDEP}] )
	x11-libs/gtk+:3[introspection]"

DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/icons/hicolor/128x128/apps
	doins ${FILESDIR}/pympress.png
}
