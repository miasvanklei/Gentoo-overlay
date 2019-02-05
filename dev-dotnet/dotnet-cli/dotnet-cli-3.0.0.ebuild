# Copyright 2019 Mias vn Klei
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"
CORECLR_PV="${PV}-preview-27322-72"
COREFX_PV="${PV}-preview.19073.11"
MY_PV="3.0.0-preview-27324-5"
DRUNTIME_PV="3.0.100-preview-010184"
DRUNTIME="dotnet-sdk-${DRUNTIME_PV}-linux-musl-x64"

IUSE="heimdal libressl"
SRC_URI="https://download.visualstudio.microsoft.com/download/pr/3e28fec3-fd16-4fb3-8eaf-bb7351ab210c/50b758004c5c307fa048b7ef41fa47d2/${DRUNTIME}.tar.gz
	https://github.com/dotnet/coreclr/archive/v${CORECLR_PV}.tar.gz -> coreclr-${PV}.tar.gz
	https://github.com/dotnet/corefx/archive/v${COREFX_PV}.tar.gz -> corefx-${PV}.tar.gz
	https://github.com/dotnet/core-setup/archive/v${MY_PV}.tar.gz -> core-setup-${PV}.tar.gz"

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
	!heimdal? ( >=app-crypt/mit-krb5-1.14.2 )
	heimdal? ( >=app-crypt/heimdal-1.5.3-r2 )
	!libressl? ( dev-libs/openssl:0= )
        libressl? ( dev-libs/libressl:0= )
	>=sys-libs/zlib-1.2.8-r1 "
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7"

S=${WORKDIR}
CLI_S="${S}/dotnetcli-${PV}"
CORECLR_S="${S}/coreclr-${CORECLR_PV}"
COREFX_S="${S}/corefx-${COREFX_PV}/"
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
	'createdump'
)

COREFX_FILES=(
	'System.IO.Compression.Native.so'
        'System.IO.Ports.Native.so'
	'System.Native.a'
	'System.Native.so'
	'System.Net.Http.Native.so'
	'System.Net.Security.Native.so'
	'System.Security.Cryptography.Native.OpenSsl.so'
)

src_unpack() {
	unpack "coreclr-${PV}.tar.gz" "corefx-${PV}.tar.gz" "core-setup-${PV}.tar.gz" "netcoredbg-${MY_PV}.tar.gz"
	mkdir "${CLI_S}" || die
	cd "${CLI_S}" || die
        unpack "${DRUNTIME}.tar.gz"
}

src_prepare() {
	for file in "${CORECLR_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${MY_PV}/${file}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${MY_PV}/${file}" || die
	done

	for file in "${CRYPTO_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${MY_PV}/${file}" || die
	done

        cd "${CORECLR_S}" || die
	eapply ${FILESDIR}/fix-build-clr.patch
	eapply ${FILESDIR}/fix-assembly.patch
	eapply ${FILESDIR}/reserved-function.patch
        cd "${COREFX_S}" || die
	eapply ${FILESDIR}/sane-cflags.patch
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
	./src/corehost/build.sh --arch amd64 --hostver ${MY_PV} \
        --fxrver ${MY_PV} --policyver ${MY_PV} --commithash a9190d4 --apphostver ${MY_PV} || die

	cd "${NETCOREDBG_S}" || die
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCLR_DIR="${CORECLR_S}" ../
	make
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App/${MY_PV}"
        local ddest_sdk="${ddest}/sdk/${DRUNTIME_PV}"

	dodir "${dest}"
	cp -pPR "${CLI_S}"/* "${ddest}" || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${CORECLR_S}/bin/Product/Linux.x64.Release/${file}" "${ddest_core}" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${COREFX_S}/artifacts/bin/native/Linux-x64-Release/${file}" "${ddest_core}" || die
	done

        cp -pP "${CORESETUP_S}/cli/fxr/libhostfxr.so" "${ddest}/host/fxr/${MY_PV}/" || die
        cp -pP "${CORESETUP_S}/cli/hostpolicy/libhostpolicy.so" "${ddest_core}" || die
	cp -pP "${CORESETUP_S}/cli/dotnet/dotnet" "${ddest}" || die
	cp -pP "${CORESETUP_S}/cli/apphost/apphost" "${ddest_sdk}/AppHostTemplate" || die

	dosym "${dest}/dotnet" "/usr/bin/dotnet"
}
