# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python3_5)

inherit vcs-snapshot distutils-r1

DESCRIPTION="PyCryptodome is a self-contained Python package of low-level cryptographic primitives."
HOMEPAGE="https://github.com/Legrandin/pycryptodome"
SRC_URI="https://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND} dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} ${PN}/test/run_tests.py --group=local || die
}
