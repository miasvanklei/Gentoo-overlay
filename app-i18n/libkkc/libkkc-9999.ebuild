# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 vala

DESCRIPTION="Japanese Kana Kanji conversion library"
HOMEPAGE="https://github.com/ueno/libkkc"

EGIT_REPO_URI="https://github.com/ueno/libkkc.git"
EGIT_BRANCH="master"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc +nls static-libs"

COMMON_DEPEND=">=dev-libs/glib-2.24:2
	>=dev-libs/json-glib-1.0
	dev-libs/libgee:0.8"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	virtual/pkgconfig
	>=dev-libs/gobject-introspection-0.9.0
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}"
PDEPEND="app-i18n/libkkc-data
	app-i18n/skk-jisyo"

DOCS=( README.md )

src_prepare() {
	eapply "${FILESDIR}"/disable-tests.patch
	eapply_user
	eautoreconf
	vala_src_prepare
}

src_configure(){
	econf	$(use_enable doc docs) \
		$(use_enable nls) \
		 --enable-introspection \
		$(use_enable static-libs static)
}

src_compile() {
	LIBS="-lm" emake
}
