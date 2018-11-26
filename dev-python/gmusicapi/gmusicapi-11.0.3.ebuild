# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit vcs-snapshot distutils-r1

DESCRIPTION="An unofficial api for Google Play Music"
HOMEPAGE="https://github.com/simon-weber/gmusicapi"
SRC_URI="https://github.com/simon-weber/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/appdirs-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.3.1[${PYTHON_USEDEP}]
	>=dev-python/gpsoauth-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/mock-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.6.0[${PYTHON_USEDEP}]
	dev-python/validictory[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.18[${PYTHON_USEDEP}]
	>=dev-python/MechanicalSoup-0.4.0[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	dev-python/pathtools[${PYTHON_USEDEP}]
	dev-python/proboscis[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/proboscis[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} ${PN}/test/run_tests.py --group=local || die
}
