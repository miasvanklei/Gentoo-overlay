# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Python Language Worker for Azure Functions V1 Runtime"
HOMEPAGE="https://github.com/Azure/azure-functions-python-worker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
        dev-python/azure-functions[${PYTHON_USEDEP}]
"

src_prepare() {
	dos2unix pyproject.toml
	eapply "${FILESDIR}/dont-install-tests.patch"

	default
}
