# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Sans-I/O wrapper of Google Music API calls."
HOMEPAGE="https://github.com/thebigmunch/google-music-proto"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/attrs-18.2[${PYTHON_USEDEP}]
	>=dev-python/audio-metadata-0.5[${PYTHON_USEDEP}]
	>=dev-python/marshmallow-2.0[${PYTHON_USEDEP}]
	>=dev-python/pendulum-2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
