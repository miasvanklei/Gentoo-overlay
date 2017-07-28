# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDEBASE="kdevelop"
KNAME="kdev-rust"
EGIT_REPONAME="kdev-rust"
PYTHON_COMPAT=( python3_{4,5,6} )

inherit python-single-r1 kde5

DESCRIPTION="Rust plugin for KDevelop"
IUSE=""
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep threadweaver)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-rust/ast-redux
	dev-util/kdevplatform:5
"
RDEPEND="${DEPEND}
	dev-util/kdevelop:5
"

RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}"/fix-template.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}
