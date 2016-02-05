# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
BOTO="f7574aa6cc2c819430c1f05e9a1a1a666ef8169b"
CHROME_BREAKPAD="4ee7e1a703d066861b7bf6fce28526f8ed07dcd6"
GOOGLE_BREAKPAD="d0b34abafbf97ec594cc5ea851c2ccbfd2a0f2f8"
BRIGHTRAY="49a86c123f4cc43f4dca886ded612104a8a1fec6"
CRASHPAD="5b777419c303d8aa7930239d8ef755475f1ede57"
DEPOT_TOOLS_1="4fa73b8ca6899bc69577932b80145a6bf07e4424"
DEPOT_TOOLS_2="e3a3fd4"
NATIVE_MATE="21cda4e7fcff592f33f989c1fea575658281711d"
NODE="edfbc29d09425f2f387c52d77f6351b6ce101659"
REQUESTS="e4d59bedfd3c7f4f254f4f5d036587bcd8152458"
LIBCHROMIUMCONTENT="17a4337f7948a45b5ea4b8f391df152ba8db5979"
GYP="e0ee72ddc7fb97eb33d530cf684efcbe4d27ecb3"
GOOGLE_STYLEGUIDE="ba88c8a53f1b563c43fc063cc048e5efdc238c18"
PYTHON_PATCH="a336a458016ced89aba90dfc3f4c8222ae3b1403"
CHROME_VERSION="45.0.2454.85"

SRC_URI="https://github.com/atom/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/boto/boto/archive/${BOTO}.zip -> boto.zip
	https://github.com/atom/chromium-breakpad/archive/${CHROME_BREAKPAD}.zip -> chrome-breakpad.zip
	https://github.com/svn2github/python-patch/archive/${PYTHON_PATCH}.zip -> python-patch.zip
	https://github.com/atom/libchromiumcontent/archive/${LIBCHROMIUMCONTENT}.zip ->  libchromiumcontent.zip
	https://github.com/svn2github/gyp/archive/${GYP}.zip -> gyp.zip
	https://github.com/svn2github/sgss-mirror-google-styleguide/archive/${GOOGLE_STYLEGUIDE}.zip -> google-styleguide.zip
	https://github.com/atom/brightray/archive/${BRIGHTRAY}.zip -> brightray.zip
	https://github.com/atom/crashpad/archive/${CRASHPAD}.zip -> crashpad.zip
	https://github.com/zcbenz/native-mate/archive/${NATIVE_MATE}.zip -> native-mate.zip
	https://github.com/atom/node/archive/${NODE}.zip -> node.zip
	https://github.com/kennethreitz/requests/archive/${REQUESTS}.zip -> requests.zip
	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${CHROME_VERSION}-lite.tar.xz
	https://chromium.googlesource.com/external/google-breakpad/src.git/+archive/${GOOGLE_BREAKPAD}.tar.gz -> google-breakpad.tar.gz
	https://chromium.googlesource.com/chromium/tools/depot_tools.git/+archive/${DEPOT_TOOLS_1}.tar.gz -> depot-tools-1.tar.gz
	https://chromium.googlesource.com/chromium/tools/depot_tools.git/+archive/${DEPOT_TOOLS_2}.tar.gz -> depot-tools-2.tar.gz
	"
inherit eutils

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=">=net-libs/nodejs-4.0
	<=net-libs/nodejs-4.9
	x11-libs/gtk+:2
	x11-libs/libnotify
	sys-devel/llvm[clang]
	app-accessibility/speech-dispatcher
	dev-libs/re2
	"

src_unpack()
{
	unpack ${P}.tar.gz
	cd ${S}/vendor || die

	unpack boto.zip
	rm -r boto || die
	mv boto-${BOTO} boto || die

	unpack chrome-breakpad.zip
	rm -r breakpad || die
	mv chromium-breakpad-${CHROME_BREAKPAD} breakpad || die

	unpack brightray.zip
	rm -r brightray || die
	mv brightray-${BRIGHTRAY} brightray || die

	unpack node.zip
	rm -r node || die
	mv node-${NODE} node || die

	unpack crashpad.zip
	rm -r crashpad || die
	mv crashpad-${CRASHPAD} crashpad || die

	unpack native-mate.zip
	rm -r native_mate || die
	mv native-mate-${NATIVE_MATE} native_mate || die

	unpack requests.zip
	rm -r requests || die
	mv requests-${REQUESTS} requests || die

	cd depot_tools || die
	unpack depot-tools-2.tar.gz
	cd ../

	cd breakpad/src || die
	unpack google-breakpad.tar.gz
	cd ../../brightray/vendor || die

	unpack gyp.zip
	rm -r gyp || die
	mv gyp-${GYP} gyp || die

	unpack google-styleguide.zip
	rm -r google-styleguide || die
	mv sgss-mirror-google-styleguide-${GOOGLE_STYLEGUIDE} gyp || die

	unpack libchromiumcontent.zip
	rm -r libchromiumcontent || die
	mv libchromiumcontent-${LIBCHROMIUMCONTENT} libchromiumcontent || die

	cd libchromiumcontent/vendor/chromium || die
	unpack chromium-${CHROME_VERSION}-lite.tar.xz
	mv chromium-${CHROME_VERSION} src || die

	cd ../depot_tools || die
	unpack depot-tools-2.tar.gz
	cd ../

	unpack python-patch.zip
	rm -r python-patch || die
	mv python-patch-${PYTHON_PATCH} python-patch || die
}

src_prepare()
{
	epatch ${FILESDIR}/musl-fixes.patch
	epatch ${FILESDIR}/use-system-libs.patch
	epatch ${FILESDIR}/local-libchromiumcontent.patch
	epatch ${FILESDIR}/musl-clang-nodebug.patch
	epatch ${FILESDIR}/use-system-clang.patch
	epatch ${FILESDIR}/musl-fixes-chromium.patch
	epatch ${FILESDIR}/chromium-system-jinja-r7.patch
	epatch ${FILESDIR}/fix-build-after-removeing-bundles-libs.patch
	epatch ${FILESDIR}/no-execinfo.patch

	cd vendor/brightray/vendor/libchromiumcontent/vendor/chromium/src || die
	build/linux/unbundle/remove_bundled_libraries.py \
		'base/third_party/dmg_fp' \
		'base/third_party/dynamic_annotations' \
		'base/third_party/icu' \
		'base/third_party/nspr' \
		'base/third_party/superfasthash' \
		'base/third_party/symbolize' \
		'base/third_party/valgrind' \
		'base/third_party/xdg_mime' \
		'base/third_party/xdg_user_dirs' \
		'breakpad/src/third_party/curl' \
		'chrome/third_party/mozilla_security_manager' \
		'courgette/third_party' \
		'crypto/third_party/nss' \
		'net/third_party/mozilla_security_manager' \
		'net/third_party/nss' \
		'third_party/WebKit' \
		'third_party/analytics' \
		'third_party/angle' \
		'third_party/angle/src/third_party/compiler' \
		'third_party/boringssl' \
		'third_party/brotli' \
		'third_party/cacheinvalidation' \
		'third_party/cld_2' \
		'third_party/cros_system_api' \
		'third_party/cython/python_flags.py' \
		'third_party/devscripts' \
		'third_party/dom_distiller_js' \
		'third_party/dom_distiller_js/dist/proto_gen/third_party/dom_distiller_js' \
		'third_party/ffmpeg' \
		'third_party/fips181' \
		'third_party/flot' \
		'third_party/google_input_tools' \
		'third_party/google_input_tools/third_party/closure_library' \
		'third_party/google_input_tools/third_party/closure_library/third_party/closure' \
		'third_party/hunspell' \
		'third_party/iccjpeg' \
		'third_party/jstemplate' \
		'third_party/khronos' \
		'third_party/leveldatabase' \
		'third_party/libXNVCtrl' \
		'third_party/libaddressinput' \
		'third_party/libjingle' \
		'third_party/libphonenumber' \
		'third_party/libsecret' \
		'third_party/libsrtp' \
		'third_party/libudev' \
		'third_party/libusb' \
		'third_party/libvpx' \
		'third_party/libvpx/source/libvpx/third_party/x86inc' \
		'third_party/libxml/chromium' \
		'third_party/libyuv' \
		'third_party/lss' \
		'third_party/lzma_sdk' \
		'third_party/mesa' \
		'third_party/modp_b64' \
		'third_party/mojo' \
		'third_party/mt19937ar' \
		'third_party/npapi' \
		'third_party/openmax_dl' \
		'third_party/opus' \
		'third_party/ots' \
		'third_party/pdfium' \
		'third_party/pdfium/third_party/agg23' \
		'third_party/pdfium/third_party/base' \
		'third_party/pdfium/third_party/bigint' \
		'third_party/pdfium/third_party/freetype' \
		'third_party/pdfium/third_party/lcms2-2.6' \
		'third_party/pdfium/third_party/libjpeg' \
		'third_party/pdfium/third_party/libopenjpeg20' \
		'third_party/pdfium/third_party/zlib_v128' \
		'third_party/polymer' \
		'third_party/protobuf' \
		'third_party/qcms' \
		'third_party/readability' \
		'third_party/sfntly' \
		'third_party/skia' \
		'third_party/smhasher' \
		'third_party/sqlite' \
		'third_party/tcmalloc' \
		'third_party/trace-viewer' \
		'third_party/trace-viewer/tracing/third_party/components/polymer' \
		'third_party/trace-viewer/tracing/third_party/d3' \
		'third_party/trace-viewer/tracing/third_party/gl-matrix' \
		'third_party/trace-viewer/tracing/third_party/jszip' \
		'third_party/trace-viewer/tracing/third_party/tvcm' \
		'third_party/trace-viewer/tracing/third_party/tvcm/third_party/beautifulsoup/polymer_soup.py' \
		'third_party/trace-viewer/tracing/third_party/tvcm/third_party/rcssmin' \
		'third_party/trace-viewer/tracing/third_party/tvcm/third_party/rjsmin' \
		'third_party/usrsctp' \
		'third_party/web-animations-js' \
		'third_party/webdriver' \
		'third_party/webrtc' \
		'third_party/widevine' \
		'third_party/x86inc' \
		'third_party/zlib/google' \
		'url/third_party/mozilla' \
		'v8/src/third_party/fdlibm' \
		'v8/src/third_party/valgrind' \
		--do-remove || die
}

src_configure()
{
	local myconf=""
	myconf+="-Ddisable_sse2=1
		 -Ddisable_pnacl=1
                 -Ddisable_nacl=1
                 -Ddisable_glibc=1
                 -Ddisable_fatal_linker_warnings=1
                 -Duse_allocator=none
                 -Dclang=1
                 -Dis_clang=true
                 -Dhost_clang=0
                 -Dclang_use_chrome_plugins=0
                 -Dwerror=
                 -Dfastbuild=2
                 -Duse_system_bzip2=1
                 -Duse_system_flac=1
                 -Duse_system_harfbuzz=1
                 -Duse_system_icu=1
                 -Duse_system_jsoncpp=1
                 -Duse_system_libevent=1
                 -Duse_system_libjpeg=1
                 -Duse_system_libpng=1
                 -Duse_system_libwebp=1
                 -Duse_system_libxml=1
                 -Duse_system_libxslt=1
                 -Duse_system_minizip=1
                 -Duse_system_nspr=1
                 -Duse_system_re2=1
                 -Duse_system_snappy=1
                 -Duse_system_speex=1
                 -Duse_system_xdg_utils=1
                 -Duse_system_zlib=1
                 -Dicu_use_data_file_flag=0
                 -Duse_system_yasm=1
                 -Dlogging_like_official_build=1
                 -Dlinux_link_gsettings=1
                 -Dlinux_link_libpci=1
                 -Dlinux_link_libspeechd=1
                 -Dlibspeechd_h_prefix=speech-dispatcher/"

	cd vendor/brightray/vendor/libchromiumcontent/vendor/chromium/src || die
	build/linux/unbundle/replace_gyp_files.py ${myconf} || die
	cd ../../../
	./script/update -t x64 || die
	cd ../../../../
}

src_compile()
{
	cd vendor/brightray/vendor/libchromiumcontent || die
	./script/build -t x64 -c static_library || die

	cd ../../../../ || die
	./script/bootstrap.py -v --libcc_source_path vendor/brightray/vendor/libchromiumcontent/vendor/chromium/src --libcc_shared_library_path vendor/brightray/vendor/libchromiumcontent/vendor/chromium/src/out/Debug --libcc_static_library_path vendor/brightray/vendor/libchromiumcontent/vendor/chromium/src/out/Release || die
	./script/build.py -c R || die
}

src_install()
{
	dolib.so out/R/libnode.so
	insinto /usr/share/atom
	doins out/R/content_shell.pak
	doins -r out/R/locales
	doins out/R/natives_blob.bin
	doins out/R/snapshot_blob.bin
	doins -r out/R/resources
	exeinto /usr/share/atom
	newexe out/R/electron atom
}
