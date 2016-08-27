# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(pypy python2_7)

inherit vcs-snapshot distutils-r1

DESCRIPTION="A wrapper interface around gmusicapi"
HOMEPAGE="https://github.com/simon-weber/gmusicapi"
SRC_URI="https://github.com/thebigmunch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/gmusicapi[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.18[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/proboscis[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${PYTHON} ${PN}/test/run_tests.py --group=local || die
}
