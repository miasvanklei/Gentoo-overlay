# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson

DESCRIPTION="Listen to internet radio"
HOMEPAGE="https://gitlab.gnome.org/World/Shortwave"

SRC_URI="https://gitlab.gnome.org/World/Shortwave/uploads/823870933d66693170571fdf09f2e355/${P}.tar.xz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	>=dev-db/sqlite-3
	>=dev-libs/openssl-1
	>=sys-apps/dbus-1
	>=dev-libs/glib-2
	>=gui-libs/gtk-4
	>=x11-libs/gdk-pixbuf-2
	>=media-libs/gstreamer-1.16
	>=media-plugins/gst-plugins-meta-1.16[mp3,http,aac,opus]
	>=media-libs/gst-plugins-base-1.16
	>=media-libs/gst-plugins-bad-1.16
	>=media-libs/gst-plugins-good-1.16
	>=gui-libs/libadwaita-1.0.0
	>=media-libs/libshumate-1.0.0
"

DEPEND="${RDEPEND}"

BUILD_DIR="${WORKDIR}/${P}_build"

src_prepare () {
	# fix lfs64 symbols in getrandom
	eapply "${FILESDIR}/musl-lfs64.patch"
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/getrandom/.cargo-checksum.json

	# fix vendor until cargo supports -C
	mkdir -p "${BUILD_DIR}"
	mv vendor "${BUILD_DIR}/vendor" || die
	mv .cargo "${BUILD_DIR}/.cargo" || die

	eapply_user
}

pkg_preinst() {
	gnome2_pkg_preinst
}
pkg_postinst() {
	gnome2_pkg_postinst
}
pkg_postrm() {
	gnome2_pkg_postrm
}
