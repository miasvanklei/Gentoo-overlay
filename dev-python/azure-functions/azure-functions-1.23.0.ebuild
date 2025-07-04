# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Azure Functions Python SDK"
HOMEPAGE="https://github.com/Azure/azure-functions-python-library"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}/dont-install-tests.patch"
)

RDEPEND="
        dev-python/werkzeug[${PYTHON_USEDEP}]
"
