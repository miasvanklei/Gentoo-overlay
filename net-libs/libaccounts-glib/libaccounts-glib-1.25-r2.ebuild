# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..9} )
inherit meson python-r1

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-glib"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	doc? ( dev-util/gtk-doc )
"

# fails
RESTRICT="test"

S="${WORKDIR}/${PN}-VERSION_${PV}"

PATCHES=(
	"${FILESDIR}"/bugus-dependencies.patch
	"${FILESDIR}/${P}-assert-failure.patch"
)

src_prepare() {
	default

	use doc || sed -e "/^subdir('docs')$/d" -i meson.build || die
}

src_configure() {
	python_foreach_impl run_in_build_dir meson_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_install() {
	einstalldocs
	python_foreach_impl run_in_build_dir meson_src_install
	python_foreach_impl python_optimize
}
