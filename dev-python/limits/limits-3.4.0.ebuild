# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1 pypi

DESCRIPTION="utilities to implement rate limiting"
HOMEPAGE="https://github.com/alisaifee/limits"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]
        dev-python/packaging[${PYTHON_USEDEP}]
        dev-python/typing-extensions[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/use-importlib-std.patch"
)

