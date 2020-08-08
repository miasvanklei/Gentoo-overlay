# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools libtool flag-o-matic python-any-r1

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="https://github.com/gdraheim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
        https://dev.gentoo.org/~asturm/distfiles/${PN}-0.13.69-man.tar.xz
        doc? ( https://dev.gentoo.org/~asturm/distfiles/${PN}-0.13.69-html.tar.xz )"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc sdl static-libs test"

RDEPEND="
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( app-arch/zip )"

PATCHES=(
	"${FILESDIR}"/zziplib-0.13.69-001-SDL-test.patch
	"${FILESDIR}"/zziplib-0.13.69-002-disable-docs.patch
	"${FILESDIR}"/zziplib-0.13.69-003-largefile.patch
	"${FILESDIR}"/zziplib-0.13.69-004-perror.patch
)

src_prepare() {
	default
	eautoreconf

	python_fix_shebang .

	# workaround AX_CREATE_PKGCONFIG_INFO bug #353195
	sed -i \
		-e '/ax_create_pkgconfig_ldflags/s:$LDFLAGS::' \
		-e '/ax_create_pkgconfig_cppflags/s:$CPPFLAGS::' \
		configure || die

	# zziplib tries to install backwards compat symlinks we dont want
	sed -i -e '/^zzip-postinstall:/s|$|\ndisable-this:|' Makefile.in || die
	sed -i -e '/^install-exec-hook:/s|$|\ndisable-this:|' zzip/Makefile.in || die

	elibtoolize

	# Do an out-of-tree build as their configure will do it automatically
	# otherwise and that can lead to funky errors. #492816
	mkdir -p build
}

src_configure() {
	cd "${S}"/build

	append-flags -fno-strict-aliasing # bug reported upstream
	export ac_cv_path_XMLTO= # man pages are bundled in .tar's

	local myeconfargs=(
		$(use_enable sdl)
		$(use_enable static-libs static)
	)

	# Disable aclocal probing as the default path works #449156
	ECONF_SOURCE=${S} ACLOCAL=true \
		econf "${myeconfargs[@]}"
	MAKEOPTS+=' -C build'
}

src_install() {
        use doc && local HTML_DOCS=( "${WORKDIR}"/html/. )
        default
        doman "${WORKDIR}"/man3/*
        find "${D}" -name '*.la' -type f -delete || die
}

src_test() {
        # need this because `make test` will always return true
        # tests fail with -j > 1 (bug #241186)
        emake -j1 check
}
