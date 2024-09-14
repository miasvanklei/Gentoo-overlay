# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"
SRC_URI="https://github.com/dotnet/runtime/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=app-crypt/mit-krb5-1.14.2
	>=dev-libs/openssl-1.0.2h-r2
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=net-misc/curl-7.49.0
	>=sys-libs/zlib-1.2.8-r1
"
DEPEND="${RDEPEND}
	>=dev-build/cmake-3.3.1-r1
	>=sys-devel/gettext-0.19.7
	>=dev-build/make-4.1-r1"

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
	'libclrgc.so'
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'createdump'
	'corehost/singlefilehost'
)

CORESETUP_FILES=(
	'libhostpolicy.so'
        'libhostfxr.so'
)

PACK_FILES=(
	'apphost'
	'libnethost.a'
	'libnethost.so'
)

S="${WORKDIR}/runtime-${PV}"

pkg_setup() {
	if use arm64; then
		DARCH=arm64
	elif use amd64; then
		DARCH=x64
	fi

	TARGET="linux-musl-${DARCH}"
	export CORECLR_S="${S}/src/coreclr"
	export COREFX_S="${S}/src/native/libs"
	export CORESETUP_S="${S}/src/native/corehost"
	export RUNTIME_PACK="packs/Microsoft.NETCore.App.Host.${TARGET}/current/runtimes/${TARGET}/native"
	export ARTIFACTS_COREFX="${S}/artifacts/bin/native/linux-${DARCH}-Release"
	export ARTIFACTS_CORECLR="${S}/artifacts/bin/coreclr/linux.${DARCH}.Release"
	export ARTIFACTS_CORESETUP="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"
}

src_prepare() {
	# create version manually (do not depend on dotnet)
	cat <<- _EOF_ > "${S}"/eng/native/version/runtime_version.h
		#define RuntimeAssemblyMajorVersion $(ver_cut 1)
		#define RuntimeAssemblyMinorVersion $(ver_cut 2)

		#define RuntimeFileMajorVersion 42
		#define RuntimeFileMinorVersion 42
		#define RuntimeFileBuildVersion 42
		#define RuntimeFileRevisionVersion 42424

		#define RuntimeProductMajorVersion $(ver_cut 1)
		#define RuntimeProductMinorVersion $(ver_cut 2)
		#define RuntimeProductPatchVersion $(ver_cut 3)

		#define RuntimeProductVersion ${PV}
	_EOF_

	mkdir -p "${S}"/artifacts/obj || die
	cp "${S}"/eng/native/version/runtime_version.h "${S}"/artifacts/obj/runtime_version.h

	eapply "${FILESDIR}"/skipmanaged-corehost.patch

	eapply_user
}

src_compile() {
	local dest_core="${SDK_S}/shared/Microsoft.NETCore.App"
	export CLR_CC="$(which $(tc-getCC))"
	export CLR_CXX="$(which $(tc-getCXX))"

	einfo "building corefx"
	cd "${COREFX_S}" || die
	./build-native.sh ${DARCH} Release verbose skipgenerateversion keepnativesymbols || die


	einfo "building coreclr"
	cd "${CORECLR_S}" || die
	./build-runtime.sh ${DARCH} Release verbose skiptests skipmanaged skipnuget skiprestore skiprestoreoptdata keepnativesymbols || die

	einfo "building coresetup"
	cd "${CORESETUP_S}" || die
	./build.sh ${DARCH} Release verbose skipmanaged keepnativesymbols hostver ${PV} fxrver ${PV} policyver ${PV} \
		commithash 770d630b apphostver ${PV} coreclrartifacts ${ARTIFACTS_CORECLR} nativelibsartifacts ${ARTIFACTS_COREFX} || die
}

src_install() {
        local dest_core="/usr/share/dotnet"
	local dest="${D}${dest_core}"
	local dest_pack="${dest}/${RUNTIME_PACK}"
	local dest_app="${dest}/shared/Microsoft.NETCore.App/current"
	local dest_app_rel="${dest_core}/shared/Microsoft.NETCore.App/current"
	local dest_fxr="${dest_core}/host/fxr/current"

	mkdir -p "${dest_app}" || die
	mkdir -p "${dest_pack}" || die

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${ARTIFACTS_COREFX}/${file}" "${dest_app}/" || die
	done

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORECLR}/${file}" "${dest_app}/" || die
	done

	for file in "${CORESETUP_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORESETUP}/${file}" "${dest_app}/" || die
	done

	for file in "${PACK_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORESETUP}/${file}" "${dest_pack}/" || die
	done

	dosym "${dest_app_rel}/libhostfxr.so" "${dest_fxr}/libhostfxr.so"

	# dotnet
	cp -pP "${ARTIFACTS_CORESETUP}/dotnet" "${dest}" || die
	dosym "${dest_core}/dotnet" "/usr/bin/dotnet"

	# create dummy symlink, fix acces violation
	dosym /dev/null /usr/share/dotnet/metadata
}
