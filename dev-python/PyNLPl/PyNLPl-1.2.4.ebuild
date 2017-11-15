# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_{6,7} python3_{1,2,3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="Python library to support Wikipedia articles"
HOMEPAGE="https://github.com/goldsmith/wikipedia http://pypi.python.org/pypi/wikipedia/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE=""

COMMON_DEPEND="${PYTHON_DEPEND}"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${DEPEND}"
