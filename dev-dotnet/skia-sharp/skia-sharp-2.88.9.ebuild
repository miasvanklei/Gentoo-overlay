# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ninja-utils

DESCRIPTION="The Skia 2D Graphics library from Google exposed to .NET languages and runtimes across the board"
HOMEPAGE="https://github.com/mono/SkiaSharp"

SKIA_COMMIT="4bed689c9c9eb77a120c6a9d54af6a572c85d1c2"

THIRD_PARTY_DEPS=(
	"zlib https://chromium.googlesource.com/chromium/src/third_party 3ca9f16f02950edffa391ec19cea856090158e9e"
	"dng_sdk https://android.googlesource.com/platform/external c8d0c9b1d16bfda56f15165d39e0ffa360a11123"
	"piex https://android.googlesource.com/platform/external bb217acdca1cc0c16b704669dd6f91a1b509c406"
)

SRC_URI="https://github.com/mono/skia/archive/${SKIA_COMMIT}.tar.gz -> ${PN}-${SKIA_COMMIT}.tar.gz"

update_SRC_URI() {
	local uri dep commit

        for p in "${THIRD_PARTY_DEPS[@]}"; do
		set -- $p
		dep=$1 uri=$2 commit=$3

                SRC_URI+=" ${uri}/${dep}.git/+archive/${commit}.tar.gz -> ${PN}-${dep}-${commit}.tar.gz"
        done
}

update_SRC_URI

S="${WORKDIR}/${PN}-${SKIA_COMMIT}"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/libwebp
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

BDEPEND="dev-build/gn"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/dont-strip.patch"
	"${FILESDIR}/missing-include.patch"
	"${FILESDIR}/cxx17-deprecated-result_of.patch"
)

src_unpack() {
        local dep commit

	mkdir "${S}"
	tar -C "${S}" -x -o --strip-components 1 -f "${DISTDIR}/${PN}-${SKIA_COMMIT}.tar.gz" || die

        for p in "${THIRD_PARTY_DEPS[@]}"; do
		set -- $p
		dep=$1 commit=$3

		local destdir="${S}/third_party/externals/${dep}/"
		mkdir -p "${destdir}" || die
		tar -C "${destdir}" -x -o -f "${DISTDIR}/${PN}-${dep}-${commit}.tar.gz" || die
		cp "${S}/third_party/${dep}/"* "${destdir}"
	done
}

src_configure() {
	local myconf_gn=()
	local BUILD_CFLAGS="${CFLAGS} -I/usr/include/freetype2 -DSKIA_C_DLL"

	local extra_cflags=""
	for cflag in $BUILD_CFLAGS; do
		extra_cflags+="\"${cflag}\","
	done

	local extra_ldflags=""
	for ldflag in $LDFLAGS; do
		extra_ldflags+="\"${ldflag}\","
	done

	myconf_gn+=(
		cc=\"${CC}\"
		cxx=\"${CXX}\"
		extra_cflags=[${extra_cflags}]
		extra_ldflags=[${extra_ldflags}]
		skia_enable_gpu=true
		skia_enable_tools=false
		skia_use_dng_sdk=true
		skia_use_icu=false
		skia_use_piex=true
		skia_use_sfntly=false
		is_component_build=false
		is_debug=false
		is_official_build=true
		linux_soname_version=\"${PV}\"
	)

	myconf_gn="${myconf_gn[@]}"
	echo "gn gen out --args=${myconf_gn% }"
	gn gen out --args="${myconf_gn% }" || die
}

src_compile() {
	eninja -C out SkiaSharp
}

src_install() {
	dolib.so "${S}"/out/libSkiaSharp.so.${PV}
	dosym libSkiaSharp.so.${PV} /usr/lib/libSkiaSharp.so.2
	dosym libSkiaSharp.so.2 /usr/lib/libSkiaSharp.so
}
