# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
RESTRICT="mirror"
KEYWORDS="~amd64 ~arm64"
SLOT="0"

# msbuild version
MY_PV=$(ver_cut 0-3)
# build date
BPV=$(ver_cut 5-)
# build date version
CPV=${BPV:0:4}.${BPV:4:2}.${BPV:6:2}.${BPV:8:2}.${BPV:10:2}

DESCRIPTION="Microsoft Build Engine (MSBuild), XML-based platform for building applications"
LICENSE="MIT" # https://github.com/mono/linux-packaging-msbuild/blob/master/LICENSE
HOMEPAGE="https://docs.microsoft.com/visualstudio/msbuild/msbuild"
SRC_URI="https://download.mono-project.com/sources/msbuild/${PN}-${MY_PV}+xamarinxplat.${CPV}.tar.xz -> ${P}.tar.xz"
IUSE=""

RDEPEND="
	>=dev-lang/mono-6.0
	virtual/dotnet-core
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	eapply "${FILESDIR}"/mono-msbuild-license-case.patch
	eapply "${FILESDIR}"/mono-msbuild-use-bash.patch

	eapply_user
}

src_compile() {
	export DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR=/usr/share/dotnet

	# no telemetry or first time experience
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1

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
	find "${D}" -name "*.pdb" -delete

	# msbuild needs a link to libhostfxr
	hostfxr=/usr/lib/mono/msbuild/Current/bin/SdkResolvers/Microsoft.DotNet.MSBuildSdkResolver/libhostfxr.so
	dosym /usr/share/dotnet/host/fxr/current/libhostfxr.so $hostfxr
}
