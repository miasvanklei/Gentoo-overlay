# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A CLI utility for interacting with Google Music."
HOMEPAGE="https://github.com/thebigmunch/google-music-scripts"
SRC_URI="https://github.com/thebigmunch/google-music-scripts/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=">=dev-python/appdirs-1.4[${PYTHON_USEDEP}]
	>=dev-python/audio-metadata-0.1[${PYTHON_USEDEP}]
	>=dev-python/click-6.0[${PYTHON_USEDEP}]
	>=dev-python/click-default-group-1.2[${PYTHON_USEDEP}]
	>=dev-python/google-music-2.0[${PYTHON_USEDEP}]
	>=dev-python/google-music-utils-1.1[${PYTHON_USEDEP}]
	>=dev-python/logzero-1.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
