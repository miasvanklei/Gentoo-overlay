# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Simple persistent cache storage, with different cache eviction strategies, and optional compression"
HOMEPAGE="https://coveralls.io/github/desbma/web_cache?branch=master"

S="${WORKDIR}/${PN/-/_}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
