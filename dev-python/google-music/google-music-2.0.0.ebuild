# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Google Music API wrapper."
HOMEPAGE="https://github.com/thebigmunch/google-music"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=">=dev-python/appdirs-1.4[${PYTHON_USEDEP}]
	>=dev-python/audio-metadata-0.1[${PYTHON_USEDEP}]
	>=dev-python/google-music-proto-2.1[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.5[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-1.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-5.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
