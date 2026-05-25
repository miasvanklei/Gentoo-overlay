# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="azurefunctions-extensions-base"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Azure Functions Extensions Base library for Python"
HOMEPAGE="https://github.com/Azure/azure-functions-python-extensions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
