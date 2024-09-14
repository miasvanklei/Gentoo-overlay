# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 pypi

DESCRIPTION="Fortran Language Server (fortls)"
HOMEPAGE="https://github.com/hansec/fortran-language-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	dev-python/json5[${PYTHON_USEDEP}]
"
