# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_7)

inherit vcs-snapshot distutils-r1

DESCRIPTION="An unofficial api for Google Play Music"
HOMEPAGE="https://github.com/simon-weber/gmusicapi"
SRC_URI="https://github.com/hickford/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/requests-2.6.0[${PYTHON_USEDEP}]
	 >=dev-python/beautifulsoup-4.4.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND} dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} ${PN}/test/run_tests.py --group=local || die
}
