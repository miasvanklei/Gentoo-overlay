# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )
PYPI_NO_NORMALIZE="True"
PYPI_PN="flask-wtf"

inherit distutils-r1 pypi

DESCRIPTION="Simple integration of Flask and WTForms"
HOMEPAGE="https://pythonhosted.org/Flask-WTF"
SRC_URI="https://github.com/wtforms/flask-wtf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/babel-1[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-babel[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	>=dev-python/wtforms-1.0.5[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinxcontrib-log-cabinet \
	dev-python/sphinx-issues
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# tries to access things over the network
	tests/test_recaptcha.py
	# unpackaged Flask-Uploads
	tests/test_file.py
)
