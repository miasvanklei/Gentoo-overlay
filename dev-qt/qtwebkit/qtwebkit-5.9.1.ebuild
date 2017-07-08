# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit python-any-r1 cmake-utils ruby-single

DESCRIPTION="WebKit rendering library for the Qt5 framework"
SRC_VERSION="5.212.0-alpha2"
SRC_URI="https://github.com/annulen/webkit/releases/download/${PN}-${SRC_VERSION}/${PN}-${SRC_VERSION}.tar.xz"
SLOT=5/$(get_version_component_range 1-2)

IUSE="geolocation gstreamer +jit multimedia opengl X spell test orientation printsupport webp"
REQUIRED_USE="?? ( gstreamer multimedia )"

S=${WORKDIR}/${PN}-${SRC_VERSION}

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	~dev-qt/qtcore-${PV}[icu]
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtsql-${PV}
	~dev-qt/qtwidgets-${PV}
	media-libs/fontconfig:1.0
	media-libs/libpng:0=
	>=sys-libs/zlib-1.2.5
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	geolocation? ( ~dev-qt/qtpositioning-${PV} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	multimedia? ( ~dev-qt/qtmultimedia-${PV}[widgets] )
	orientation? ( ~dev-qt/qtsensors-${PV} )
	opengl? ( ~dev-qt/qtopengl-${PV} )
	printsupport? ( ~dev-qt/qtprintsupport-${PV} )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/rubygems
"

PATCHES=(
	"${FILESDIR}/qtwebkit-musl.patch"
)

src_configure() {
	local ruby_interpreter=""

	if has_version "virtual/rubygems[ruby_targets_ruby24]"; then
                ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby24)"
	elif has_version "virtual/rubygems[ruby_targets_ruby23]"; then
                ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby23)"
	elif has_version "virtual/rubygems[ruby_targets_ruby22]"; then
                ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby22)"
	else
                ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby21)"
	fi

	local mycmakeargs=(
		$(cmake-utils_use_enable test API_TESTS)
		$(cmake-utils_use_enable geolocation GEOLOCATION)
		$(cmake-utils_use_enable gstreamer VIDEO)
		$(cmake-utils_use_enable gstreamer WEB_AUDIO)
		$(cmake-utils_use_enable jit)
		$(cmake-utils_use_enable spell SPELLCHECK SPELLCHECK)
		$(cmake-utils_use_enable orientation DEVICE_ORIENTATION)
		$(cmake-utils_use_enable printsupport PRINT_SUPPORT)
		$(cmake-utils_use_enable X X11_TARGET)
		$(cmake-utils_use_enable opengl OPENGL)
		$(cmake-utils_use_use gstreamer)
		$(cmake-utils_use_use multimedia qt_multimedia)
		-DUSE_SYSTEM_MALLOC=ON
		-DCMAKE_BUILD_TYPE=Release
		-DPORT=Qt
		${ruby_interpreter}
	)

        cmake-utils_src_configure
}

src_compile() {
        cmake-utils_src_compile
}

src_install() {
        cmake-utils_src_install

	# Fix pkgconfig files
	sed -e 's|qt/Qt5WebKit|qt/QtWebKit|' -i "${D}"/usr/lib/pkgconfig/Qt5WebKit.pc
	sed -e 's|qt/Qt5WebKitWidgets|qt/QtWebKitWidgets|' -i "${D}"/usr/lib/pkgconfig/Qt5WebKitWidgets.pc
	sed -e '/Name/a Description: Qt WebKit module' -i "${D}"/usr/lib/pkgconfig/Qt5WebKit.pc
	sed -e '/Name/a Description: Qt WebKitWidgets module' -i "${D}"/usr/lib/pkgconfig/Qt5WebKitWidgets.pc
}
