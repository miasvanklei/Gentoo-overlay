# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

RUNTIME_PV="rtm.20519.4"
SDK_PV="5.0.100"
SDK="dotnet-sdk-${SDK_PV}-linux"
NDBG_PV="1.2.0-635"
NDBG="netcoredbg-${NDBG_PV}"

SRC_URI="
	arm64? (
		https://download.visualstudio.microsoft.com/download/pr/27840e8b-d61c-472d-8e11-c16784d40091/ae9780ccda4499405cf6f0924f6f036a/${SDK}-arm64.tar.gz
	)
	amd64? (
		https://download.visualstudio.microsoft.com/download/pr/820db713-c9a5-466e-b72a-16f2f5ed00e2/628aa2a75f6aa270e77f4a83b3742fb8/${SDK}-x64.tar.gz
	)
	https://github.com/dotnet/runtime/archive/v${PV}-${PV}.tar.gz -> ${P}.tar.gz
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

CORECLR_FILES=(
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libdbgshim.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'createdump'
)

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

CORESETUP_FILES=(
	'libhostpolicy.so'
)

PACK_FILES=(
	'apphost'
        'singlefilehost'
	'libnethost.a'
	'libnethost.so'
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
	for file in "${CORECLR_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${CORESETUP_FILES[@]}"; do
		rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/${file}" || die
	done

	for file in "${PACK_FILES[@]}"; do
		rm "${SDK_S}/${RUNTIME_PACK}/${file}" || die
	done

	# unecessary files
	rm "${SDK_S}/shared/Microsoft.NETCore.App/${PV}/libnethost.a" || die
	rm -r "${SDK_S}/sdk/${SDK_PV}/AppHostTemplate" || die

	rm "${SDK_S}/host/fxr/${PV}/libhostfxr.so" || die
	rm "${SDK_S}/dotnet" || die

	# netcoredbg builddir
	mkdir "${NDBG_S}/build"

	eapply "${FILESDIR}"/musl-build.patch
	eapply "${FILESDIR}"/sane-buildflags.patch
	eapply "${FILESDIR}"/fix-duplicate-symbols.patch
	eapply "${FILESDIR}"/fix-lld.patch
	eapply "${FILESDIR}"/option-to-not-strip.patch
	eapply "${FILESDIR}"/fix-shared-profiling-header.patch
	eapply "${FILESDIR}"/disable-stack-size.patch
#	eapply "${FILESDIR}"/use-system-unwind.patch

	# netcoredbg patches
	pushd ${NDBG_S} >/dev/null || die
	eapply "${FILESDIR}"/netcoredbg-5.0.patch
	popd >/dev/null

	default
}

src_compile() {
	local artifacts_corefx="${S}/artifacts/bin/native/Linux-${DARCH}-Release"
	local artifacts_coreclr="${S}/artifacts/bin/coreclr/Linux.${DARCH}.Release"

	einfo "building corefx"
	cd "${COREFX_S}" || die
	./build-native.sh ${DARCH} release verbose skipgenerateversion keepnativesymbols || die

	einfo "building coreclr"
	cd "${CORECLR_S}" || die
	./build-runtime.sh ${DARCH} release verbose skiptests skipmanaged skipnuget skiprestore skiprestoreoptdata keepnativesymbols || die

	einfo "building coresetup"
	cd "${CORESETUP_S}" || die
	./build.sh ${DARCH} release verbose skipmanaged keepnativesymbols hostver ${PV} fxrver ${PV} policyver ${PV} \
		commithash 3c523a6 apphostver ${PV} coreclrartifacts ${artifacts_coreclr} \
		nativelibsartifacts ${artifacts_corefx} || die

	cd ${NDBG_S}/build || die
	cmake -DCMAKE_INSTALL_PREFIX=/ -DCORECLR_DIR=${CORECLR_S} -DDOTNET_DIR=${SDK_S} ../ || die
	emake
}

src_install() {
	local dest="${D}/opt/dotnet"
	local dest_core="${dest}/shared/Microsoft.NETCore.App"
	local dest_pack="${dest}/${RUNTIME_PACK}"
	local artifacts_corefx="${S}/artifacts/bin/native/Linux-${DARCH}-Release"
	local artifacts_coreclr="${S}/artifacts/bin/coreclr/Linux.${DARCH}.Release"
	local artifacts_coresetup="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"
	local dotnetpv="3.1.100"

	# sdk
	mkdir -p "${dest}" || die
	cp -rpP "${SDK_S}"/* ${dest} || die

	# runtime
	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${artifacts_coreclr}/${file}" "${dest_core}/${PV}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${artifacts_corefx}/${file}" "${dest_core}/${PV}" || die
	done

	for file in "${CORESETUP_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_core}/${PV}" || die
	done

	for file in "${PACK_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_pack}" || die
	done

        # compability symlink with .net core 3.1
	pushd "${dest_core}" >/dev/null || die
	ln -s "${PV}" "${dotnetpv}"
	popd >/dev/null

        # compability symlink with .net core 3.1
	pushd "${dest}/packs/Microsoft.NETCore.App.Host.${TARGET}" >/dev/null || die
	ln -s "${PV}" "${dotnetpv}"
	popd >/dev/null

	# netcoredbg
	cd ${NDBG_S}/build
	make install DESTDIR="${dest_core}/${PV}"
	dosym "${dest_core}/${PV}/netcoredbg" "/usr/bin/netcoredbg"

	# dotnet
	dolib.so "${artifacts_coresetup}/libhostfxr.so"
	dosym "/usr/lib/libhostfxr.so" "/opt/dotnet/host/fxr/${PV}/libhostfxr.so"
	cp -pP "${artifacts_coresetup}/dotnet" "${dest}" || die
	dosym "${dest}/dotnet" "/usr/bin/dotnet"

	newenvd - "60dotnet" <<-_EOF_
		DOTNET_ROOT="/opt/dotnet"
	_EOF_
}
