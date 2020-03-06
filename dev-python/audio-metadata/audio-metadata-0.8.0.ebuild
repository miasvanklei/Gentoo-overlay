# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A library for reading and, in the future, writing metadata from audio files."
HOMEPAGE="https://github.com/thebigmunch/audio-metadata"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND=">=dev-python/attrs-18.2[${PYTHON_USEDEP}]
	<dev-python/attrs-19.4[${PYTHON_USEDEP}]
	>=dev-python/bidict-0.17[${PYTHON_USEDEP}]
	>=dev-python/bitstruct-6.0.0[${PYTHON_USEDEP}]
	<dev-python/bitstruct-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0[${PYTHON_USEDEP}]
	<dev-python/more-itertools-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/pprintpp-0.4[${PYTHON_USEDEP}]
	>=dev-python/tbm-utils-2.3[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.0[${PYTHON_USEDEP}]
"
