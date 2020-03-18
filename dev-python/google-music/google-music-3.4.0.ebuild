# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A Google Music API wrapper."
HOMEPAGE="https://github.com/thebigmunch/google-music"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/appdirs-1.4[${PYTHON_USEDEP}]
	>=dev-python/audio-metadata-0.8[${PYTHON_USEDEP}]
	>=dev-python/google-music-proto-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.11[${PYTHON_USEDEP}]
	<dev-python/httpx-1.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.5[${PYTHON_USEDEP}]
	>=dev-python/tbm-utils-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-5.0[${PYTHON_USEDEP}]
	<dev-python/tenacity-7.0[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"