# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"
SRC_URI="
        amd64? ( "https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${PV}/aspnetcore-runtime-${PV}-linux-musl-x64.tar.gz" )
        arm64? ( "https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${PV}/aspnetcore-runtime-${PV}-linux-musl-arm64.tar.gz" )
	https://github.com/dotnet/runtime/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

NUGETS=(
	"microsoft.aspnetcore.app.runtime.linux-musl-arm64 arm64 ${PV}"
	"microsoft.aspnetcore.app.runtime.linux-musl-x64 amd64 ${PV}"
	"microsoft.netcore.app.runtime.linux-musl-arm64 arm64 ${PV}"
	"microsoft.netcore.app.runtime.linux-musl-x64 amd64 ${PV}"
)

update_SRC_URI() {
        local name arch version
        for p in "${NUGETS[@]}"; do
                set -- $p
                name=$1 arch=$2 version=$3

                SRC_URI+=" ${arch}? ( https://api.nuget.org/v3-flatcontainer/${name}/${version}/${name}.${version}.nupkg )"
        done
}

update_SRC_URI

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
	'libSystem.Globalization.Native.so'
	'libSystem.IO.Compression.Native.so'
	'libSystem.IO.Ports.Native.so'
	'libSystem.Native.so'
	'libSystem.Net.Security.Native.so'
	'libSystem.Security.Cryptography.Native.OpenSsl.so'
)

CORECLR_FILES=(
	'libclrgc.so'
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'createdump'
)

PACK_FILES=(
	'apphost'
	'coreclr_delegates.h'
	'hostfxr.h'
	'libnethost.a'
	'libnethost.so'
	'nethost.h'
)

S="${WORKDIR}/runtime-${PV}"

pkg_setup() {
	if use arm64; then
		export DARCH=arm64
	elif use amd64; then
		export DARCH=x64
	fi

	TARGET="linux-musl-${DARCH}"
	export CORECLR_S="${S}/src/coreclr"
	export COREFX_S="${S}/src/native/libs"
	export CORESETUP_S="${S}/src/native/corehost"
	export APPHOST_PACK="packs/Microsoft.NETCore.App.Host.${TARGET}/current/runtimes/${TARGET}/native"
	export ARTIFACTS_COREFX="${S}/artifacts/bin/native/linux-${DARCH}-Release"
	export ARTIFACTS_CORECLR="${S}/artifacts/bin/coreclr/linux.${DARCH}.Release"
	export ARTIFACTS_CORESETUP="${S}/artifacts/bin/linux-musl-${DARCH}.Release/corehost"
}

src_unpack() {
        local a

        for a in ${A} ; do
                case "${a}" in
                        *.nupkg)
                                local basename=${a%.nupkg*}
                                local destdir=${WORKDIR}/${basename}
                                mkdir "${destdir}" || die
				unzip -qq -d "${destdir}" "${DISTDIR}/${a}" || die
                        ;;

			*aspnet*)
				local basename=${a%.tar.*}
                                local destdir=${WORKDIR}/${basename}
                                mkdir "${destdir}" || die
				tar -C "${destdir}" -x -o --strip-components 1 \
					-f "${DISTDIR}/${a}" || die
			;;

                        *)
                                # Fallback to the default unpacker.
                                unpack "${a}"
                                ;;
                esac
        done
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
	eapply "${FILESDIR}"/fix-missing-definition.patch
	eapply "${FILESDIR}"/fix-and-cleanup-set-stacksize.patch

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

install_runtime_pack() {
        local packname="$1"
	local packdir="${D}/usr/lib/dotnet-sdk/packs/${packname}.Runtime.linux-musl-${DARCH}"
	local runtimepackdir="${PV}/runtimes/linux-musl-${DARCH}"
	local libdir="${packdir}/${runtimepackdir}/lib/net$(ver_cut 1-2)"
	local nativedir="${packdir}/${runtimepackdir}/native"

	mkdir -p "${libdir}" || die
	pushd "${libdir}" >/dev/null
	ln -s "../../../../../../../shared/${packname}/current/"*.dll ./ || die
	ln -s "../../../../../../../shared/${packname}/current/"*.json ./ || die
	popd >/dev/null

	if [[ "${packname}" == "Microsoft.NETCore.App" ]]; then
		mkdir -p "${nativedir}" || die
		pushd "${nativedir}" >/dev/null
		ln -s "../../../../../../shared/${packname}/current/"*.so ./ || die
		ln -s "../../../../../../shared/${packname}/current/createdump" ./ || die
		popd >/dev/null
	fi

	cp -r "${WORKDIR}/${packname,,}.runtime.linux-musl-${DARCH}.${PV}/data" "${packdir}" || die
}

src_install() {
        local dest="${D}/usr/lib/dotnet-sdk"
	local dest_apphost_pack="${dest}/${APPHOST_PACK}"
	local dest_netcore_app="${dest}/shared/Microsoft.NETCore.App/current"
	local dest_aspnetcore_app="${dest}/shared/Microsoft.AspNetCore.App/current"
	local dest_fxr="${dest}/host/fxr/current"
	local pack_src_dir="${WORKDIR}/aspnetcore-runtime-${PV}-linux-musl-${DARCH}"

	mkdir -p "${dest_netcore_app}" || die
	mkdir -p "${dest_aspnetcore_app}" || die
	mkdir -p "${dest_apphost_pack}" || die
	mkdir -p "${dest_fxr}" || die

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${ARTIFACTS_COREFX}/${file}" "${dest_netcore_app}/" || die
	done

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORECLR}/${file}" "${dest_netcore_app}/" || die
	done

	for file in "${PACK_FILES[@]}"; do
		cp -pP "${ARTIFACTS_CORESETUP}/${file}" "${dest_apphost_pack}/" || die
	done

        cp -pP "${pack_src_dir}/shared/Microsoft.NETCore.App/${PV}/"*.dll "${dest_netcore_app}" || die
        cp -pP "${pack_src_dir}/shared/Microsoft.NETCore.App/${PV}/"*.json "${dest_netcore_app}" || die

        cp -pP "${pack_src_dir}/shared/Microsoft.AspNetCore.App/${PV}/"*.dll "${dest_aspnetcore_app}" || die
        cp -pP "${pack_src_dir}/shared/Microsoft.AspNetCore.App/${PV}/"*.json "${dest_aspnetcore_app}" || die

	cp -pP "${ARTIFACTS_CORECLR}/corehost/singlefilehost" "${dest_apphost_pack}" || die
	cp -pP "${ARTIFACTS_CORESETUP}/libhostpolicy.so" "${dest_netcore_app}/" || die
	cp -pP "${ARTIFACTS_CORESETUP}/libhostfxr.so" "${dest_fxr}/" || die
	cp -pP "${ARTIFACTS_CORESETUP}/dotnet" "${dest}" || die

	install_runtime_pack Microsoft.NETCore.App
	install_runtime_pack Microsoft.AspNetCore.App

	dosym ../lib/dotnet-sdk/dotnet /usr/bin/dotnet
}
