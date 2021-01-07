# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

RUNTIME_PV="servicing.20575.16"
SDK_PV="5.0.101"
SDK="dotnet-sdk-${SDK_PV}-linux"
NDBG_PV="1.2.0-672"
NDBG="netcoredbg-${NDBG_PV}"

SRC_URI="
	arm64? (
		https://download.visualstudio.microsoft.com/download/pr/2add7523-39ec-413a-b8a7-24361cc4e599/30489ebd7ebcc723da48a64669860fd0/${SDK}-arm64.tar.gz
	)
	amd64? (
		https://download.visualstudio.microsoft.com/download/pr/a0487784-534a-4912-a4dd-017382083865/be16057043a8f7b6f08c902dc48dd677/${SDK}-x64.tar.gz
	)
	https://github.com/dotnet/runtime/archive/v${PV}-${RUNTIME_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Samsung/netcoredbg/archive/${NDBG_PV}.tar.gz -> ${NDBG}.tar.gz"

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

S=${WORKDIR}/runtime-${PV}-${RUNTIME_PV}

COREFX_FILES=(
	'libSystem.IO.Compression.Native.a'
	'libSystem.IO.Compression.Native.so'
	'libSystem.Native.a'
	'libSystem.Native.so'
	'libSystem.Net.Security.Native.a'
	'libSystem.Net.Security.Native.so'
	'libSystem.Security.Cryptography.Native.OpenSsl.a'
	'libSystem.Security.Cryptography.Native.OpenSsl.so'
)

CORECLR_FILES=(
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libdbgshim.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'createdump'
)

CORESETUP_FILES=(
	'libhostpolicy.so'
)

PACK_FILES=(
	'apphost'
        'singlefilehost'
	'libnethost.a'
	'libnethost.so'
)

NDBG_FILES=(
	'Microsoft.CodeAnalysis.dll'
	'Microsoft.CodeAnalysis.CSharp.dll'
	'Microsoft.CodeAnalysis.Scripting.dll'
	'Microsoft.CodeAnalysis.CSharp.Scripting.dll'
	'SymbolReader.dll'
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
	export RUNTIME_PACK="packs/Microsoft.NETCore.App.Host.${TARGET}/${PV}/runtimes/${TARGET}/native"
	export NDBG_S="${WORKDIR}/${NDBG}"

	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
}

src_unpack() {
	mkdir "${SDK_S}"
	pushd "${SDK_S}" >/dev/null || die
	unpack "${DSDK}.tar.gz"
	popd >/dev/null

	unpack "${P}.tar.gz"
	unpack "${NDBG}.tar.gz"
}

src_prepare() {
	# remove native binaries/libraries
	for file in "${COREFX_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${CORECLR_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${CORESETUP_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${PACK_FILES[@]}"; do
		rm "${SDK_S}/${RUNTIME_PACK}/${file}" || die
	done

	# unecessary file
	rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/libnethost.a" || die

	rm "${SDK_S}/sdk/${SDK_PV}/AppHostTemplate/apphost" || die
	rm "${SDK_S}/host/fxr/${PV}/libhostfxr.so" || die
	rm "${SDK_S}/dotnet" || die

	eapply "${FILESDIR}"/musl-build.patch
	eapply "${FILESDIR}"/sane-buildflags.patch
	eapply "${FILESDIR}"/fix-duplicate-symbols.patch
	eapply "${FILESDIR}"/fix-lld.patch
	eapply "${FILESDIR}"/option-to-not-strip.patch
	eapply "${FILESDIR}"/fix-shared-profiling-header.patch
	eapply "${FILESDIR}"/disable-stack-size.patch
	eapply "${FILESDIR}"/use-system-unwind.patch
	eapply "${FILESDIR}"/libunwind-arm64.patch

	# netcoredbg patches
	pushd ${NDBG_S} >/dev/null || die
	eapply "${FILESDIR}"/netcoredbg-fix-build.patch
	popd >/dev/null

	default
}

src_compile() {
	local artifacts_corefx="${S}/artifacts/bin/native/Linux-${DARCH}-Release"
	local artifacts_coreclr="${S}/artifacts/bin/coreclr/Linux.${DARCH}.Release"
	local artifacts_coresetup="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"
	local dest_core="${SDK_S}/shared/Microsoft.NETCore.App"
	local dest_pack="${SDK_S}/${RUNTIME_PACK}"

	einfo "building corefx"
	cd "${COREFX_S}" || die
	./build-native.sh ${DARCH} Release verbose skipgenerateversion keepnativesymbols || die

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${artifacts_corefx}/${file}" "${dest_core}/${PV}" || die
	done

	einfo "building coreclr"
	cd "${CORECLR_S}" || die
	./build-runtime.sh ${DARCH} Release verbose skiptests skipmanaged skipnuget skiprestore skiprestoreoptdata keepnativesymbols || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${artifacts_coreclr}/${file}" "${dest_core}/${PV}" || die
	done

	einfo "building coresetup"
	cd "${CORESETUP_S}" || die
	./build.sh ${DARCH} Release skipmanaged keepnativesymbols hostver ${PV} fxrver ${PV} policyver ${PV} \
		commithash 3c523a6 apphostver ${PV} coreclrartifacts ${artifacts_coreclr} \
		nativelibsartifacts ${artifacts_corefx} || die
	for file in "${CORESETUP_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_core}/${PV}" || die
	done

	for file in "${PACK_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_pack}" || die
	done

	cp "${artifacts_coresetup}/apphost" "${SDK_S}/sdk/${SDK_PV}/AppHostTemplate/apphost"
	cp "${artifacts_coresetup}/libhostfxr.so" "${SDK_S}/host/fxr/${PV}/libhostfxr.so"
	cp -pP "${artifacts_coresetup}/dotnet" "${SDK_S}" || die

	einfo "building System.Private.CoreLib.dll"
	pushd ${CORECLR_S}/src/System.Private.CoreLib >/dev/null || die
	${SDK_S}/dotnet build -c Release /p:Platform=${ARCH} /p:TargetArchitecture=${DARCH} || die
	popd >/dev/null
	cp "${artifacts_coreclr}/IL/System.Private.CoreLib.dll" "${dest_core}/${PV}" || die

	einfo "building netcoredbg"
	cd "${NDBG_S}" || die
	cmake -DCMAKE_INSTALL_PREFIX=/ -DCORECLR_DIR=${CORECLR_S} -DDOTNET_DIR=${SDK_S} ./ || die
	emake VERBOSE=1
}

src_install() {
        local dest_core="/usr/share/dotnet"
	local dest="${D}${dest_core}"
	local dest_app="${dest}/shared/Microsoft.NETCore.App"

	# install everything
	mkdir -p "${dest}" || die
	cp -rpP "${SDK_S}"/* ${dest} || die

	# netcoredbg
	cd ${NDBG_S} || die
	make install DESTDIR="${dest}/${PV}" || die
	dosym "${dest}/${PV}/netcoredbg" "/usr/bin/netcoredbg"

	# dotnet
	dosym "${dest}/dotnet" "/usr/bin/dotnet"
}
