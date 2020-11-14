# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
RESTRICT="mirror"
KEYWORDS="~amd64 ~arm64"
SLOT="0"

# msbuild version
MY_PV=$(ver_cut 0-2)
# build date
BPV=$(ver_cut 4-)
# build date version
CPV=${BPV:0:4}.${BPV:4:2}.${BPV:6:2}.${BPV:8:2}.${BPV:10:2}

DESCRIPTION="Microsoft Build Engine (MSBuild), XML-based platform for building applications"
LICENSE="MIT" # https://github.com/mono/linux-packaging-msbuild/blob/master/LICENSE
HOMEPAGE="https://docs.microsoft.com/visualstudio/msbuild/msbuild"
SRC_URI="https://download.mono-project.com/sources/msbuild/${PN}-${MY_PV}+xamarinxplat.${CPV}.tar.xz -> ${P}.tar.xz"
IUSE=""

RDEPEND="
	>=dev-lang/mono-6.0
	dev-dotnet/dotnet-cli
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	eapply "${FILESDIR}/fix_bashisms.patch"
	eapply "${FILESDIR}/copy_hostfxr.patch"
	eapply "${FILESDIR}/license_check_is_case_sensitive.diff"
	eapply "${FILESDIR}/case_sensitive_dotnetbits.patch"
	eapply "${FILESDIR}/fix-compile.patch"
	eapply "${FILESDIR}/dont-download-dotnet.patch"

	eapply_user
}

src_compile() {
	export DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR=/opt/dotnet
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	./eng/cibuild_bootstrapped_msbuild.sh \
	--host_type mono --configuration Release --skip_tests /p:DisableNerdbankVersioning=true || die

	stage1/mono-msbuild/msbuild mono/build/install.proj /p:MonoInstallPrefix=${S}/target/usr \
	/p:Configuration=Release-MONO /p:IgnoreDiffFailure=true || die

	sed -i "s@${S}/target@@g" ${S}/target/usr/bin/msbuild

	find ${S}/target/usr/lib/mono/ -name Microsoft.DiaSymReader.Native.*dll -delete
	find ${S}/target/usr/lib/mono/ -name *.dylib -delete
	find ${S}/target/usr/lib/mono/ -name *.so -delete
}

src_install() {
	cp -dr --no-preserve='ownership' ${S}/target/usr "${D}"
}
