# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy )

RESTRICT="test"

inherit distutils-r1

DESCRIPTION="Natural sorting for Python"
HOMEPAGE="https://pypi.org/project/natsort/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="arm amd64 ia64 x86"
IUSE="test"

BDEPEND="${BDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		virtual/python-pathlib[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
	)"

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}
