# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Gnome-shell extension that combines the dash and, application launchers and systray into a single panel."
HOMEPAGE="https://github.com/jderose9/dash-to-panel"
SRC_URI="https://github.com/jderose9/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"

DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	gnome-base/gnome-common
	gnome-base/gnome-shell
"

RDEPEND="${DEPEND}"

# S="${WORKDIR}/${PN}-${PV/v/}"

src_install() {
	emake INSTALLBASE="${D}/usr/share/gnome-shell/extensions" VERSION=${PV} install

	insinto "/usr/share/glib-2.0/schemas/"
		doins "schemas/org.gnome.shell.extensions.dash-to-panel.gschema.xml"

	dodoc README.md
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	elog "Use eselect gnome-shell-extensions to select the newly installed extension. "
	elog "You may have to relogin to see the extension. "
	elog "Install gnome-extra/gnome-tweak-tool for easier configuration. "

}
