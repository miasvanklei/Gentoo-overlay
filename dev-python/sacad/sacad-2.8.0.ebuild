# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Smart Automatic Cover Art Downloader"
HOMEPAGE="https://github.com/desbma/sacad https://pypi.org/project/sacad/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/bitarray[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/web-cache[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]"
