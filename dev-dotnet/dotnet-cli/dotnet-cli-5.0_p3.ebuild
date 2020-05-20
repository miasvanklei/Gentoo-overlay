# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

RUNTIME_PV="5.0.0-preview.3.20214.6"
SDK_PV="5.0.100-preview.3.20216.6"
SDK="dotnet-sdk-${SDK_PV}-linux"

SRC_URI="arm64? (
		https://download.visualstudio.microsoft.com/download/pr/67d8e63e-753d-4900-997f-b332bb63b025/303b7ac855985d077056ef4552f4a4e9/${SDK}-arm64.tar.gz
	)
	amd64? (
		https://download.visualstudio.microsoft.com/download/pr/7ceba34e-5d50-4b23-b326-0a7d02b4decd/62dd73db9be67127a5645ef0efb0bba4/${SDK}-x64.tar.gz
	)
	https://github.com/dotnet/runtime/archive/v${RUNTIME_PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=app-crypt/mit-krb5-1.14.2
	>=dev-libs/openssl-1.0.2h-r2
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=net-misc/curl-7.49.0
	>=sys-libs/zlib-1.2.8-r1 "
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/gettext-0.19.7
	>=sys-devel/make-4.1-r1"

S=${WORKDIR}/runtime-${RUNTIME_PV}

CORECLR_FILES=(
	'libclrjit.so'
	'libcoreclr.so'
	'libdbgshim.so'
	'libmscordaccore.so'
	'libcoreclrtraceptprovider.so'
	'libmscordbi.so'
	'createdump'
)

COREFX_FILES=(
	'libSystem.Globalization.Native.a'
	'libSystem.Globalization.Native.so'
	'libSystem.IO.Compression.Native.a'
	'libSystem.IO.Compression.Native.so'
	'libSystem.IO.Ports.Native.so'
	'libSystem.IO.Ports.Native.a'
	'libSystem.Native.a'
	'libSystem.Native.so'
	'libSystem.Net.Security.Native.a'
	'libSystem.Net.Security.Native.so'
	'libSystem.Security.Cryptography.Native.OpenSsl.a'
	'libSystem.Security.Cryptography.Native.OpenSsl.so'
)

pkg_setup() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	DSDK="${SDK}-${DARCH}"
	TARGET="linux-${DARCH}"
	export SDK_S="${WORKDIR}/${DSDK}"
	export CORECLR_S="${S}/src/coreclr"
	export COREFX_S="${S}/src/libraries/Native"
	export CORESETUP_S="${S}/src/installer/corehost"
	export RUNTIME_PACK="packs/Microsoft.NETCore.App.Host.${TARGET}/${RUNTIME_PV}/runtimes/${TARGET}/native"
}

src_unpack() {
	mkdir "${SDK_S}"
	pushd "${SDK_S}" || die
	unpack "${DSDK}.tar.gz"
	popd

	unpack "${P}.tar.gz"
}

src_prepare() {
	# remove native binaries/libraries
	for file in "${CORECLR_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${RUNTIME_PV}/${file}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${RUNTIME_PV}/${file}" || die
	done

	rm "${SDK_S}/shared/Microsoft.NETCore.App/${RUNTIME_PV}/libhostpolicy.so" || die
	rm "${SDK_S}/shared/Microsoft.NETCore.App/${RUNTIME_PV}/libnethost.a" || die

	rm "${SDK_S}/sdk/${SDK_PV}/AppHostTemplate/apphost" || die
	rm "${SDK_S}/host/fxr/${RUNTIME_PV}/libhostfxr.so" || die
	rm "${SDK_S}/${RUNTIME_PACK}/libnethost.so" || die
	rm "${SDK_S}/${RUNTIME_PACK}/libnethost.a" || die
	rm "${SDK_S}/${RUNTIME_PACK}/apphost" || die
	rm "${SDK_S}/dotnet" || die

	eapply "${FILESDIR}"/musl-build.patch
	eapply "${FILESDIR}"/sane-buildflags.patch
	eapply "${FILESDIR}"/fix-duplicate-symbols.patch

	default
}

src_compile() {
	einfo "building corefx"
	cd "${COREFX_S}" || die
	./build-native.sh ${DARCH} release verbose skipgenerateversion || die

	einfo "building coreclr"
	cd "${CORECLR_S}" || die
	./build-runtime.sh ${DARCH} release verbose skiptests skipmanaged skipnuget skiprestore skiprestoreoptdata || die

	einfo "building coresetup"
	cd "${CORESETUP_S}" || die
	./build.sh ${DARCH} release verbose skipmanaged hostver ${RUNTIME_PV} fxrver ${RUNTIME_PV} policyver ${RUNTIME_PV} \
		commithash 3c523a6 apphostver ${RUNTIME_PV} || die
}

src_install() {
	local dest="${D}/opt/${P}"
	local dest_core="${dest}/shared/Microsoft.NETCore.App/${RUNTIME_PV}"
	local dest_sdk="${dest}/sdk/${SDK_PV}"
	local dest_pack="${dest}/${RUNTIME_PACK}"
	local artifacts_corefx="${S}/artifacts/bin/native/Linux-${DARCH}-Release"
	local artifacts_coreclr="${S}/artifacts/bin/coreclr/Linux.${DARCH}.Release"
	local artifacts_coresetup="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"

	mkdir -p "${dest}" || die
	cp -rpP "${SDK_S}"/* ${dest} || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${artifacts_coreclr}/${file}" "${dest_core}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${artifacts_corefx}/${file}" "${dest_core}" || die
	done

	cp -pP "${artifacts_coresetup}/apphost" "${dest_sdk}/AppHostTemplate" || die
	cp -pP "${artifacts_coresetup}/apphost" "${dest_pack}" || die
	cp -pP "${artifacts_coresetup}/libnethost.a" "${dest_pack}" || die
	cp -pP "${artifacts_coresetup}/libnethost.so" "${dest_pack}" || die
	cp -pP "${artifacts_coresetup}/dotnet" "${dest}" || die
	cp -pP "${artifacts_coresetup}/libhostfxr.so" "${dest}/host/fxr/${RUNTIME_PV}/" || die
	cp -pP "${artifacts_coresetup}/libhostpolicy.so" "${dest_core}" || die
	cp -pP "${artifacts_coresetup}/libnethost.a" "${dest_core}" || die

	dosym "${dest}/dotnet" "/usr/bin/dotnet"
}
