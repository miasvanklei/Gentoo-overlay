# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit vcs-snapshot distutils-r1

DESCRIPTION="A wrapper interface around gmusicapi"
HOMEPAGE="https://github.com/simon-weber/gmusicapi"
SRC_URI="https://github.com/thebigmunch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=">=dev-python/audio-metadata-0.1[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.10[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
