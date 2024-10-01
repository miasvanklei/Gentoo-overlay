# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYPI_NO_NORMALIZE="True"
PYPI_PN="Flask-HTTPAuth"

inherit distutils-r1 pypi

DESCRIPTION="HTTP authentication for Flask routes"
HOMEPAGE="https://pythonhosted.org/Flask-HTTPAuth"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
"
