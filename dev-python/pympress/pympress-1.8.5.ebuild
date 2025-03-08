# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Efficient, Pythonic bidirectional map implementation and related functionality"
HOMEPAGE="https://bidict.readthedocs.io"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="gstreamer"

BDEPEND="
	dev-python/babel[${PYTHON_USEDEP}]"

RDEPEND="
	app-text/poppler[cairo,introspection]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	gstreamer? ( dev-python/gst-python[${PYTHON_USEDEP}] )
	x11-libs/gtk+:3[introspection]"

DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/icons/hicolor/128x128/apps
	doins "${FILESDIR}"/pympress.png
}
