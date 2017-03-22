# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="GtkD is a D binding and OO wrapper of GTK+"
HOMEPAGE="https://github.com/gtkd-developers/GtkD"
LICENSE="MIT"

SLOT="3"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

SRC_URI="https://github.com/gtkd-developers/GtkD/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DEPEND=""
RDEPEND="${DEPEND}
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/gtksourceview-3.20:3.0
	>=media-libs/gstreamer-1.8:1.0
	>=x11-libs/vte-0.43:2.91
	dev-libs/libpeas"

GTKD_LIB_NAMES=(gtkd gtkdgl gtkdsv gstreamerd vted peasd)
GTKD_SRC_DIRS=(src srcgl srcsv srcgstreamer srcvte srcpeas)

MAJOR=3
MINOR=5.1

IUSE="static-libs"

src_prepare() {
	default
	multilib_copy_sources
}

dlang_exec() {
	echo "${@}"
	${@} || die
}

multilib_src_compile() {
	DC=/usr/bin/ldc2
	compile_libs() {

		# Build the shared library version of the component
                dlang_exec ${DC} -O5 -op -Isrc ${GTKD_SRC_DIRS[$i]}/*/*.d -shared \
		-of=lib${LIB_NAME}-${MAJOR}.so.0.${MINOR} -L=-soname=lib${LIB_NAME}-${MAJOR}.so.0
		#${DC} -v -op -Isrc ${GTKD_SRC_DIRS[$i]}/*/*.d \
		#${LDFLAGS} -shared -relocation-model=pic \
		#-L=-soname=lib${LIB_NAME}-${MAJOR}.so.0 \
		#-of=lib${LIB_NAME}-${MAJOR}.so.0.${MINOR}

		# Build the static library version
		if use static-libs; then
			local libname=lib${LIB_NAME}-${MAJOR}
			dlang_exec ${DC} -op ${SRC_DIR}/*/*.d -Isrc -lib -od=${SRC_DIR} -oq \
				${LDFLAGS} of=${libname}.a
		fi
	}

	foreach_used_component compile_libs
}

multilib_src_install() {
	install_libs() {
		# Install the shared library version of the component
		local libfile="lib${LIB_NAME}-${MAJOR}.so"
		dolib.so "${libfile}.0.${MINOR}"
		dosym "${libfile}.0.${MINOR}" "/usr/$(get_libdir)/${libfile}.0"
		dosym "${libfile}.0.${MINOR}" "/usr/$(get_libdir)/${libfile}"

		# Install the static library version
		if use static-libs; then
			dolib.a "lib${LIB_NAME}-${MAJOR}.a"
		fi
	}

	foreach_used_component install_libs
}

multilib_src_install_all() {
	# Obligatory docs
	dodoc AUTHORS README

	# Include files
	insinto "/usr/include/d/gtkd-${MAJOR}"

	install_headers() {
		files="${SRC_DIR}/*"
		doins -r ${files}
	}

	emake prefix=/usr pkgconfig-gtkd
	emake prefix=/usr pkgconfig-gtkdgl
	emake prefix=/usr pkgconfig-sv
	emake prefix=/usr pkgconfig-gstreamer
	emake prefix=/usr pkgconfig-vte
	emake prefix=/usr pkgconfig-peas

	mkdir ${D}/usr/lib/pkgconfig
        cp ${S}/*.pc ${D}/usr/lib/pkgconfig

	foreach_used_component install_headers
}

foreach_used_component() {
	for (( i = 0 ; i < ${#GTKD_LIB_NAMES[@]} ; i++ )); do
			LIB_NAME=${GTKD_LIB_NAMES[$i]} SRC_DIR=${GTKD_SRC_DIRS[$i]} ${@}
	done
}
