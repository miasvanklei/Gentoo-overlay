# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="This project provides first-class OAuth library support for Requests"
HOMEPAGE="https://github.com/requests/requests-oauthlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~amd64 ~arm"
IUSE="test"

DEPEND="test? (
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/requests-mock[${PYTHON_USEDEP}]
		)"
RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-0.6.2[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
