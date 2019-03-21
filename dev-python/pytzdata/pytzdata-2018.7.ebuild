# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="The Olson timezone database for Python."
HOMEPAGE="https://github.com/sdispater/pytzdata https://pypi.org/project/pytzdata/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	sys-libs/timezone-data"

PATCHES=(
	"${FILESDIR}"/${PV}-zoneinfo-noinstall.patch
        "${FILESDIR}"/${PV}-zoneinfo.patch
)
