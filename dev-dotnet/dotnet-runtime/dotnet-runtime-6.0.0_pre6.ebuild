# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

MY_PV="${PV/_pre/-preview.}.21352.12"
SDK_PV="6.0.100_pre6"

SRC_URI="https://github.com/dotnet/runtime/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

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

PDEPEND="=virtual/dotnet-core-${PV}"

COREFX_FILES=(
	'libSystem.IO.Compression.Native.a'
	'libSystem.IO.Compression.Native.so'
	'libSystem.Native.a'
	'libSystem.Native.so'
	'libSystem.Net.Security.Native.a'
	'libSystem.Net.Security.Native.so'
	'libSystem.Security.Cryptography.Native.OpenSsl.a'
	'libSystem.Security.Cryptography.Native.OpenSsl.so'
	'libSystem.Globalization.Native.a'
	'libSystem.Globalization.Native.so'
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

S="${WORKDIR}/runtime-${MY_PV}"

pkg_setup() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	TARGET="linux-musl-${DARCH}"
	export CORECLR_S="${S}/src/coreclr"
	export COREFX_S="${S}/src/libraries/Native"
	export CORESETUP_S="${S}/src/native/corehost"
	export RUNTIME_PACK="packs/Microsoft.NETCore.App.Host.${TARGET}/current/runtimes/${TARGET}/native"
	export ARTIFACTS_COREFX="${S}/artifacts/bin/native/Linux-${DARCH}-Release"
	export ARTIFACTS_CORECLR="${S}/artifacts/bin/coreclr/Linux.${DARCH}.Release"
}

src_prepare() {
	eapply "${FILESDIR}"/musl-build.patch
	eapply "${FILESDIR}"/skipmanaged-corehost.patch
	eapply "${FILESDIR}"/use-system-unwind.patch
	eapply "${FILESDIR}"/sane-buildflags.patch
	eapply "${FILESDIR}"/arm64-fix-duplicate-symbols.patch

	default
}

src_compile() {
	local dest_core="${SDK_S}/shared/Microsoft.NETCore.App"

	einfo "building corefx"
	cd "${COREFX_S}" || die
	./build-native.sh ${DARCH} Release verbose skipgenerateversion keepnativesymbols || die


	einfo "building coreclr"
	cd "${CORECLR_S}" || die
	./build-runtime.sh ${DARCH} Release verbose skiptests skipmanaged skipnuget skiprestore skiprestoreoptdata keepnativesymbols || die

	einfo "building coresetup"
	cd "${CORESETUP_S}" || die
	./build.sh ${DARCH} Release verbose skipmanaged keepnativesymbols hostver ${MY_PV} fxrver ${MY_PV} policyver ${MY_PV} \
		commithash 770d630b apphostver ${MY_PV} coreclrartifacts ${ARTIFACTS_CORECLR} nativelibsartifacts ${ARTIFACTS_COREFX} || die
}

src_install() {
	local artifacts_coresetup="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"

        local dest_core="/usr/share/dotnet"
	local dest="${D}${dest_core}"
	local dest_pack="${dest}/${RUNTIME_PACK}"
	local dest_app="${dest}/shared/Microsoft.NETCore.App/current"
	local dest_fxr="${dest}/host/fxr/current"

	mkdir -p "${dest_app}" || die
	mkdir -p "${dest_pack}" || die
	mkdir -p "${dest_fxr}" || die

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${ARTIFACTS_COREFX}/${file}" "${dest_app}/" || die
	done

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORECLR}/${file}" "${dest_app}/" || die
	done

	for file in "${CORESETUP_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_app}/" || die
	done

	for file in "${PACK_FILES[@]}"; do
		cp -pP "${artifacts_coresetup}/${file}" "${dest_pack}/" || die
	done

	cp -pP "${artifacts_coresetup}/dotnet" "${dest}" || die
	cp "${artifacts_coresetup}/libhostfxr.so" "${dest_fxr}/libhostfxr.so"

	# dotnet
	dosym "${dest}/dotnet" "/usr/bin/dotnet"
}
