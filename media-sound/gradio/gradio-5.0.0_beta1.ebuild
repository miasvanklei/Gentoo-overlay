EAPI=6

inherit cmake-utils gnome2-utils vala

MY_PV="${PV//_/-}"
DESCRIPTION="A GTK3 app for finding and listening to internet radio stations"
HOMEPAGE="https://github.com/haecker-felix/gradio"
SRC_URI="https://github.com/haecker-felix/gradio/archive/v5.0.0-beta1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="
	x11-libs/gtk+
	dev-libs/glib
	media-libs/gstreamer
	net-libs/webkit-gtk
	dev-libs/json-glib
	net-libs/libsoup
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare()
{
	vala_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
        gnome2_schemas_savelist
}

pkg_postinst() {
        gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}

