# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDEBASE="kdevelop"
KNAME="kdev-rust"
PYTHON_COMPAT=( python3_{4,5,6} )
EGIT_MIRROR="https://github.com/Noughmad"

inherit python-single-r1 kde5

DESCRIPTION="Python plugin for KDevelop"
IUSE=""
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kitemmodels)
	dev-util/kdevplatform:5
"
RDEPEND="${DEPEND}
	dev-util/kdevelop:5
"

RESTRICT+=" test"

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}
