# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python3_6)

inherit distutils-r1

DESCRIPTION="A python client library for Google Play Services OAuth"
HOMEPAGE="https://github.com/simon-weber/gpsoauth"
SRC_URI="mirror://pypi/g/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PATCHES=(${FILESDIR}/pycryptodome.patch)

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"
