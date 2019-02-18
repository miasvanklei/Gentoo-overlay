# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A library for reading and, in the future, writing metadata from audio files."
HOMEPAGE="https://github.com/thebigmunch/audio-metadata"
SRC_URI="https://github.com/thebigmunch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/attrs-18.2[${PYTHON_USEDEP}]
	>=dev-python/bidict-0.17[${PYTHON_USEDEP}]
	>=dev-python/bitstruct-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0[${PYTHON_USEDEP}]
	>=dev-python/pprintpp-0.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
