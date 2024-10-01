# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYPI_NO_NORMALIZE="True"
PYPI_PN="Flask-Principal"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Identity management for flask"
HOMEPAGE="https://pythonhosted.org/Flask-Principal/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
