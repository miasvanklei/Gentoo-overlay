# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vcs-snapshot

DESCRIPTION="Accounts SSO (Single Sign-On) management library for GLib applications"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="doc"

RDEPEND="
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

PATCHES=(
	"${FILESDIR}"/bugus-dependencies.patch
)

# fails
RESTRICT="test"

src_prepare() {
	default

	use doc || sed -e "/^subdir('docs')$/d" -i meson.build || die
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	einstalldocs
	meson_src_install
}
