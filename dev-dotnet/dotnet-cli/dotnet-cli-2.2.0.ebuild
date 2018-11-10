# Copyright 2017 Mias vn Klei
# Distributed under the terms of the GNU General Public License v2

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"
DOTNET_SDK="dotnet-sdk-2.2.100-preview3-009430-linux-x64.tar.gz"
DPV=2.2.0-preview3-27014-02
MY_PV="${PV}-preview3"

IUSE="heimdal"
SRC_URI="https://download.visualstudio.microsoft.com/download/pr/e7cf8f5b-b0b4-4e22-b836-89af615ad13c/4583953b976cbe658c4c84f61624e8a9/${DOTNET_SDK}
	https://github.com/dotnet/coreclr/archive/v${MY_PV}.tar.gz -> coreclr-${MY_PV}.tar.gz
	https://github.com/dotnet/corefx/archive/v${MY_PV}.tar.gz -> corefx-${MY_PV}.tar.gz
	https://github.com/dotnet/core-setup/archive/v${MY_PV}.tar.gz -> core-setup-${MY_PV}.tar.gz
	https://github.com/Samsung/netcoredbg/archive/latest.tar.gz -> netcoredbg-${MY_PV}.tar.gz"

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
CORECLR_S="${S}/coreclr-${MY_PV}"
COREFX_S="${S}/corefx-${MY_PV}/"
CORESETUP_S="${S}/core-setup-${MY_PV}/"
NETCOREDBG_S="${S}/netcoredbg-latest"

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
	unpack "coreclr-${MY_PV}.tar.gz" "corefx-${MY_PV}.tar.gz" "core-setup-${MY_PV}.tar.gz" "netcoredbg-${MY_PV}.tar.gz"
	mkdir "${CLI_S}" || die
	cd "${CLI_S}" || die
        unpack "${DOTNET_SDK}"
}

src_prepare() {
	for file in "${CORECLR_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}" || die
	done

	for file in "${CRYPTO_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${DPV}/${file}" || die
	done

        cd "${CORECLR_S}" || die
	eapply ${FILESDIR}/fix-build-clr.patch
	cd "${COREFX_S}" || die
	eapply ${FILESDIR}/fix-build-cfx.patch
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

	cd "${NETCOREDBG_S}" || die
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCLR_DIR="${CORECLR_S}" ../
	make
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
	cp -PP "${NETCOREDBG_S}/build/src/debug/netcoredbg/netcoredbg" "${ddest_core}/${DPV}/netcoredbg" || die
	cp -PP "${NETCOREDBG_S}/build/src/debug/netcoredbg/SymbolReader.dll" "${ddest_core}/${DPV}/SymbolReader.dll" || die

	dosym "/opt/dotnet_cli/dotnet" "/usr/bin/dotnet"
	dosym "/opt/dotnet_cli/shared/Microsoft.NETCore.App/${DPV}/netcoredbg" "/usr/bin/netcoredbg"
}
