# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A library for reading and, in the future, writing metadata from audio files."
HOMEPAGE="https://github.com/thebigmunch/audio-metadata"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/hyper-h2-3.0[${PYTHON_USEDEP}]
	>=dev-python/hstspreload-2019.8.27[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]")
