# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils git-r3

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="https://github.com/aitjcize/Gummi.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/aitjcize/Gummi.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

LANGS="ar ca cs da de el es fr hu it nl pl pt pt_BR ro ru sv zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="
	dev-libs/glib:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:3"

DEPEND="${RDEPEND}
	app-text/gtkspell:3
	app-text/poppler[cairo]
	x11-libs/gtksourceview:3.0
	x11-libs/pango"

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	strip-linguas ${LANGS}
	eautoreconf
	default
}

pkg_postinst() {
	elog "Gummi supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-**-"
	elog "packages for your language of choice."
}
