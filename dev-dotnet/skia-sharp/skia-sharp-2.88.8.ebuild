# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ninja-utils git-r3

DESCRIPTION="The Skia 2D Graphics library from Google exposed to .NET languages and runtimes across the board"
HOMEPAGE="https://github.com/mono/SkiaSharp"
EGIT_REPO_URI="https://github.com/mono/SkiaSharp.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~arm64"

RDEPEND="
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng
	media-libs/libwebp
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

BDEPEND="dev-build/gn"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/dont-strip.patch"
)

S="${WORKDIR}/${P}/externals/skia"

src_unpack() {
	git-r3_src_unpack

	"${S}"/tools/git-sync-deps
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
		skia_use_system_libjpeg_turbo=false
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
	eninja -C out
}

src_install() {
	dolib.so "${S}"/out/libSkiaSharp.so.${PV}
	dosym libSkiaSharp.so.${PV} /usr/lib/libSkiaSharp.so.2
	dosym libSkiaSharp.so.2 /usr/lib/libSkiaSharp.so
}
