# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

CORE_V1_0=1.0.3
CLI_V1_0=1.0.0-preview2-003156
CORECLR_V1_0=1.0.6
COREFX_V1_0=1.0.4

DIST='debian-x64'

COREFX=corefx-${COREFX_V}

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

IUSE="heimdal"
SRC_URI="https://github.com/dotnet/coreclr/archive/v${CORECLR_V1_0}.tar.gz -> coreclr-${CORECLR_V1_0}.tar.gz
	https://github.com/dotnet/corefx/archive/v${COREFX_V1_0}.tar.gz -> corefx-${COREFX_V1_0}.tar.gz
	https://download.microsoft.com/download/0/3/0/030449F5-F093-44A6-9889-E19B50A59777/sdk/dotnet-dev-${DIST}.${CLI_V1_0}.tar.gz
	https://github.com/dotnet/coreclr/archive/v${PV}.tar.gz -> coreclr-${PV}.tar.gz
	https://github.com/dotnet/corefx/archive/v${PV}.tar.gz -> corefx-${PV}.tar.gz
	https://github.com/dotnet/core-setup/archive/v${PV}.tar.gz -> core-setup-${PV}.tar.gz
	https://download.microsoft.com/download/F/D/5/FD52A2F7-65B6-4912-AEDD-4015DF6D8D22/dotnet-${PV}-sdk-${DIST}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-devel/llvm-4.0
	>=dev-util/lldb-4.0
	>=sys-libs/llvm-libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
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

PATCHES=(
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-gcc6-clang39.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-clang39-commit-9db7fb1.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-icu57-commit-352df35.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-llvm4.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-llvm4-intsafe.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-musl.patch"
	"${FILESDIR}/coreclr-${CORECLR_V1_0}-werror.patch"
	"${FILESDIR}/coreclr-${PV}-clang39-commit-9db7fb1.patch"
	"${FILESDIR}/coreclr-${PV}-exceptionhandling.patch"
	"${FILESDIR}/coreclr-${PV}-builtin-redefinition.patch"
	"${FILESDIR}/corefx-${PV}-init-tools-script.patch"
	"${FILESDIR}/coreclr-${PV}-llvm4.patch"
	"${FILESDIR}/coreclr-${PV}-llvm5.patch"
	"${FILESDIR}/coreclr-${PV}-llvm4-intsafe.patch"
	"${FILESDIR}/coreclr-${PV}-musl.patch"
	"${FILESDIR}/coreclr-${PV}-werror.patch"
	"${FILESDIR}/corefx-${COREFX_V1_0}-werror.patch"
	"${FILESDIR}/corefx-${PV}-run-script.patch"
	"${FILESDIR}/corefx-${PV}-werror.patch"
	"${FILESDIR}/core-setup-${PV}-musl.patch"
)

S=${WORKDIR}
CLI_1_0_S="${S}/tools-dotnet"
CORECLR_1_0_S="${S}/coreclr-${CORECLR_V1_0}"
COREFX_1_0_S="${S}/corefx-${COREFX_V1_0}"
CLI_S="${S}/dotnetcli-${PV}"
CORECLR_S="${S}/coreclr-${PV}"
COREFX_S="${S}/corefx-${PV}"
CORESETUP_S="${S}/core-setup-${PV}/src/corehost"

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

CRYPTO_V1_0_FILES=(
	'System.Security.Cryptography.Native.so'
)

CRYPTO_FILES=(
	'System.Security.Cryptography.Native.OpenSsl.so'
)

#pkg_pretend() {
#	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
#	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
#		die ".NET core command-line (CLI) tools require sandbox and usersandbox to be disabled in FEATURES."
#	fi
#}

src_unpack() {
	unpack "coreclr-${CORECLR_V1_0}.tar.gz" "corefx-${COREFX_V1_0}.tar.gz" "coreclr-${PV}.tar.gz" "corefx-${PV}.tar.gz" "core-setup-${PV}.tar.gz"
	mkdir "${CLI_1_0_S}" "${CLI_S}" || die
	cd "${CLI_S}" || die
	unpack "dotnet-${PV}-sdk-${DIST}.tar.gz"
	cd "${CLI_1_0_S}" || die
	unpack "dotnet-dev-${DIST}.${CLI_V1_0}.tar.gz"
}

src_prepare() {
	cp "${FILESDIR}/corefx-${PV}-buildtools.patch" "${COREFX_S}/buildtools.patch"

	for file in "${CORECLR_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${PV}/${file}"
		rm "${CLI_S}/shared/Microsoft.NETCore.App/1.0.4/${file}"
		rm "${CLI_1_0_S}/shared/Microsoft.NETCore.App/${CORE_V1_0}/${file}"
	done

	for file in "${COREFX_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${PV}/${file}"
		rm "${CLI_S}/shared/Microsoft.NETCore.App/1.0.4/${file}"
		rm "${CLI_1_0_S}/shared/Microsoft.NETCore.App/${CORE_V1_0}/${file}"
	done

	for file in "${CRYPTO_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/${PV}/${file}"
	done

	for file in "${CRYPTO_V1_0_FILES[@]}"; do
		rm "${CLI_S}/shared/Microsoft.NETCore.App/1.0.4/${file}"
		rm "${CLI_1_0_S}/shared/Microsoft.NETCore.App/${CORE_V1_0}/${file}"
	done

	default_src_prepare
}

src_compile() {
	local buildargs=""

	if use heimdal; then
		# build uses mit-krb5 by default but lets override to heimdal
		buildargs="${buildargs} cmakeargs -DHeimdalGssApi=ON"
	fi

	local dest="${CLI_1_0_S}/shared/Microsoft.NETCore.App/${CORE_V1_0}/"

	cd "${COREFX_1_0_S}" || die
	./build.sh native x64 release ${buildargs} || die

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${COREFX_1_0_S}/bin/Linux.x64.Release/Native/${file}" "${dest}" || die
	done

	for file in "${CRYPTO_V1_0_FILES[@]}"; do
		cp -pP "${COREFX_1_0_S}/bin/Linux.x64.Release/Native/${file}" "${dest}" || die
	done

	cd "${S}" || die
	rm -rf "${COREFX_1_0_S}" || die

	local cbuildargs=""
	cbuildargs="${cbuildargs} cmakeargs -DCLR_CMAKE_BUILD_TESTS=OFF"

	cd "${CORECLR_1_0_S}" || die
	./build.sh x64 release ${cbuildargs} || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${CORECLR_1_0_S}/bin/Product/Linux.x64.Release/${file}" "${dest}" || die
	done

	cd "${S}" || die
	rm -rf "${CORECLR_1_0_S}" || die

	cd "${COREFX_S}" || die
	./src/Native/build-native.sh x64 release ${buildargs} || die

	cd "${CORECLR_S}" || die
	./build.sh x64 release ${cbuildargs} || die

	cd "${CORESETUP_S}" || die
	./build.sh --arch amd64 --hostver ${PV} --fxrver ${PV} --policyver ${PV} --commithash 005db40cd1 --rid debian.8-x64
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App"

	dodir "${dest}"
	cp -pPR "${CLI_S}"/* "${ddest}" || die

	for file in "${CORECLR_FILES[@]}"; do
		cp -pP "${CORECLR_S}/bin/Product/Linux.x64.Release/${file}" "${ddest_core}/${PV}/" || die
		cp -pP "${CORECLR_S}/bin/Product/Linux.x64.Release/${file}" "${ddest_core}/1.0.4/" || die
	done

	for file in "${COREFX_FILES[@]}"; do
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/Native/${file}" "${ddest_core}/${PV}/" || die
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/Native/${file}" "${ddest_core}/1.0.4/" || die
	done

	for file in "${CRYPTO_FILES[@]}"; do
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/Native/${file}" "${ddest_core}/${PV}/" || die
	done

	for file in "${CRYPTO_V1_0_FILES[@]}"; do
		cp -pP "${COREFX_S}/bin/Linux.x64.Release/Native/${file}" "${ddest_core}/1.0.4/" || die
	done

	cp "${CORESETUP_S}/cli/exe/dotnet" "${ddest}/"
	cp "${CORESETUP_S}/cli/dll/libhostpolicy.so" "${ddest_core}/${PV}/"
	cp "${CORESETUP_S}/cli/fxr/libhostfxr.so" "${ddest_core}/${PV}/"
	cp "${CORESETUP_S}/cli/fxr/libhostfxr.so" "${ddest}/host/fxr/1.1.0/"

	dosym "../../opt/dotnet_cli/dotnet" "/usr/bin/dotnet"
}
