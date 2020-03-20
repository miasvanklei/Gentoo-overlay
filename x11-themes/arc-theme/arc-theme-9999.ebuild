# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/jnsh/arc-theme"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jnsh/arc-theme.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~arm ~ppc64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate +pre-rendered xfce"

SASSC_DEPEND="
	dev-lang/sassc
"

SVG_DEPEND="
	media-gfx/inkscape
	media-gfx/optipng
"

# Supports various GTK+3 versions and uses pkg-config to determine which
# set of files to install. Updates will break it but only this fix will
# help. See https://github.com/horst3180/arc-theme/pull/436. The same
# applies to GNOME Shell but I don't know whether that's fixable.
BDEPEND="
	cinnamon? (
		${SASSC_DEPEND}
	)
	gnome-shell? (
		${SASSC_DEPEND}
		>=gnome-base/gnome-shell-3.18
	)
	gtk2? (
		${SVG_DEPEND}
	)
	gtk3? (
		${SASSC_DEPEND}
		${SVG_DEPEND}
		virtual/pkgconfig
		>=x11-libs/gtk+-3.18:3
	)
	xfce? (
		${SVG_DEPEND}
	)
"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="
	gtk2? (
		x11-themes/gnome-themes-standard
		x11-themes/gtk-engines-murrine
	)
"

src_prepare() {
	if ! use gnome-shell; then
		eapply "${FILESDIR}"/fix-without-gnome-shell.patch
	fi

	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-openbox \
		--disable-plank \
		--disable-unity \
		$(use_enable cinnamon) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable xfce xfwm)
}
