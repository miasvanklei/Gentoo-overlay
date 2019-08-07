# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A CLI utility for interacting with Google Music."
HOMEPAGE="https://github.com/thebigmunch/google-music-scripts"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/appdirs-1.0[${PYTHON_USEDEP}]
	>=dev-python/audio-metadata-0.5[${PYTHON_USEDEP}]
	>=dev-python/google-music-3.0[${PYTHON_USEDEP}]
	>=dev-python/google-music-proto-2.4[${PYTHON_USEDEP}]
	>=dev-python/google-music-utils-2.1[${PYTHON_USEDEP}]
	>=dev-python/loguru-0.3[${PYTHON_USEDEP}]
	>=dev-python/pendulum-2.0[${PYTHON_USEDEP}]
	>=dev-python/natsort-5.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/fix-broken-setup-py.patch
)
