# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_3,3_4,3_5} )
PYTHON_REQ_USE="sqlite"

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="A non-linear video editor using the GStreamer multimedia framework"
HOMEPAGE="http://www.pitivi.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="v4l test help"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Do not forget to check pitivi/check.py for dependencies!!!
# pycanberra, gnome-desktop, libav and libnotify are optional
GST_VER="1.8.2"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-python/pycairo-1.10[${PYTHON_USEDEP}]
	>=x11-libs/cairo-1.10
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/glib-2.30.0:2

	>=dev-libs/gobject-introspection-1.34:=
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/gst-python-1.4:1.0[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pycanberra[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.8:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]

	gnome-base/librsvg:=
	gnome-base/gnome-desktop:3=[introspection]

	>=media-libs/gstreamer-${GST_VER}:1.0[introspection]
	>=media-libs/gstreamer-editing-services-${GST_VER}:1.0[introspection]
	>=media-libs/gst-plugins-base-${GST_VER}:1.0
	>=media-libs/gst-plugins-bad-${GST_VER}:1.0[gtk]
	>=media-libs/gst-plugins-good-${GST_VER}:1.0
	>=media-plugins/gst-plugins-libav-${GST_VER}:1.0
	>=media-plugins/gst-transcoder-1.8

	x11-libs/libnotify[introspection]
	>=x11-libs/gtk+-3.20.0:3[introspection]

	v4l? ( >=media-plugins/gst-plugins-v4l2-${GST_VER}:1.0 )
"

# make tests optional (remove dependency on nose), needs patch in meson.build
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-python/setuptools
	>=dev-util/intltool-0.35.5
	>=dev-util/meson-0.28.0
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )
"

src_prepare() {
	eapply ${FILESDIR}/tests-optional.patch
	eapply_user
}

src_configure() {
	# Not a normal configure
	# --buildtype=plain needed for honoring CFLAGS/CXXFLAGS and not
        # defaulting to debug
	local confargs

	if ! use help; then
		confargs+=-Ddisable-help=true
	fi

	if use test; then
		confargs+=-Denable-tests=true
	fi

	./configure --prefix=/usr --buildtype=plain ${confargs}

}

src_compile() {
	# We cannot use 'make' as it won't allow us to build verbosely
	cd mesonbuild && ninja -v
}

src_test() {
	export PITIVI_TOP_LEVEL_DIR="${S}"
	virtx emake check
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${D}"
}
