# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Simple persistent cache storage, with different cache eviction strategies, and optional compression"
HOMEPAGE="https://github.com/hellysmile/fake-useragent https://pypi.org/project/fake-useragent/"
SRC_URI="mirror://pypi/${P:0:1}/${PN/-/_}/${P/-/_}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN/-/_}-${PV}
