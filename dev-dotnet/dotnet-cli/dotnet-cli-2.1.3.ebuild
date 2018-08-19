# Copyright 2017 Mias vn Klei
# Distributed under the terms of the GNU General Public License v2

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"
DOTNET_SDK="dotnet-sdk-2.1.300-linux-x64.tar.gz"
DPV=2.1.0

IUSE="heimdal"
SRC_URI="https://download.microsoft.com/download/8/8/5/88544F33-836A-49A5-8B67-451C24709A8F/${DOTNET_SDK}
	https://github.com/dotnet/coreclr/archive/v${PV}.tar.gz -> coreclr-${PV}.tar.gz
	https://github.com/dotnet/corefx/archive/v${PV}.tar.gz -> corefx-${PV}.tar.gz
	https://github.com/dotnet/core-setup/archive/v${PV}.tar.gz -> core-setup-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-devel/llvm-4.0
	>=dev-util/lldb-4.0
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	sys-libs/llvm-libunwind
	heimdal? (
		>=app-crypt/heimdal-1.5.3-r2
	)
	!heimdal? (
		>=app-crypt/mit-krb5-1.14.2
	)
	>=sys-libs/zlib-1.2.8-r1 "
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7"

S=${WORKDIR}
CLI_S="${S}/dotnetcli-${PV}"
CORECLR_S="${S}/coreclr-${PV}"
COREFX_S="${S}/corefx-${PV}/"
CORESETUP_S="${S}/core-setup-${PV}/"

CORECLR_FILES=(
	'libclrjit.so'
	'libcoreclr.so'
	'libcoreclrtraceptprovider.so'
	'libdbgshim.so'
	'libmscordaccore.so'
	'libmscordbi.so'
	'libsos.so'
	'libsosplugin.so'
	'System.Globalization.Native.so'
)

COREFX_FILES=(
	'System.IO.Compression.Native.so'
	'System.Native.a'
	'System.Native.so'
	'System.Net.Http.Native.so'
	'System.Net.Security.Native.so'
)

CRYPTO_FILES=(
	'System.Security.Cryptography.Native.OpenSsl.so'
)

src_unpack() {
	unpack "coreclr-${PV}.tar.gz" "corefx-${PV}.tar.gz" "core-setup-${PV}.tar.gz"
	mkdir "${CLI_S}" || die
	cd "${CLI_S}" || die
        unpack "${DOTNET_SDK}"
}

src_prepare() {
	for file in "${CORECLR_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}"
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}"
	done

	for file in "${CRYPTO_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}"
	done

        cd "${CORECLR_S}" || die
	eapply ${FILESDIR}/fix-build.patch
	#eapply ${FILESDIR}/clang-6.0.patch
	#eapply ${FILESDIR}/musl.patch
        cd ..

	default_src_prepare
}

src_compile() {
	local buildargs=""

	if use heimdal; then
		# build uses mit-krb5 by default but lets override to heimdal
		buildargs="${buildargs} -cmakeargs -DHeimdalGssApi=ON"
	fi

	cd "${COREFX_S}" || die
	./src/Native/build-native.sh x64 release verbose ${buildargs} || die

	cd "${CORECLR_S}" || die
	./build.sh x64 release verbose skiptests cmakeargs -DCLR_CMAKE_WARNINGS_ARE_ERRORS=FALSE || die

	cd "${CORESETUP_S}" || die
	./src/corehost/build.sh --arch amd64 --hostver ${DPV} \
        --fxrver ${DPV} --policyver ${DPV} --commithash a9190d4 --apphostver ${DPV} || die
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App"

	dodir "${dest}"
	cp -pPR "${CLI_S}"/* "${ddest}" || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${CORECLR_S}/bin/Product/Linux.x64.Release/${file}" "${ddest_core}/${DPV}/" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/native/${file}" "${ddest_core}/${DPV}/" || die
	done

	for file in "${CRYPTO_FILES[@]}"; do
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/native/${file}" "${ddest_core}/${DPV}/" || die
	done

        cp -pP "${CORESETUP_S}/cli/fxr/libhostfxr.so" "${ddest}/host/fxr/${DPV}/" || die
        cp -pP "${CORESETUP_S}/cli/dll/libhostpolicy.so" "${ddest_core}/${DPV}/" || die
	cp -pP "${CORESETUP_S}/cli/exe/dotnet/dotnet" "${ddest}/dotnet" || die

	dosym "../../opt/dotnet_cli/dotnet" "/usr/bin/dotnet"
}
