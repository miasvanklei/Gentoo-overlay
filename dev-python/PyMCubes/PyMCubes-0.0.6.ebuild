# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_7 python3_4)

inherit distutils-r1 git-r3

DESCRIPTION="Marching cubes (and related tools) for Python"
HOMEPAGE="https://github.com/pmneila/PyMCubes"
EGIT_REPO_URI="https://github.com/pmneila/PyMCubes.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	 dev-python/numpy[${PYTHON_USEDEP}]
	 dev-python/pycollada[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
