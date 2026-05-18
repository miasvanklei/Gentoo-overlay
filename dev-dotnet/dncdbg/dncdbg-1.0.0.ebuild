# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGETS="
microsoft.codeanalysis.analyzers@3.3.3
microsoft.codeanalysis.common@4.5.0
microsoft.codeanalysis.csharp@4.5.0
microsoft.csharp@4.7.0
microsoft.netcore.platforms@1.1.0
netstandard.library@2.0.3
system.buffers@4.5.1
system.collections.immutable@6.0.0
system.memory@4.5.4
system.memory@4.5.5
system.numerics.vectors@4.4.0
system.reflection.metadata@6.0.1
system.runtime.compilerservices.unsafe@4.5.3
system.runtime.compilerservices.unsafe@6.0.0
system.text.encoding.codepages@6.0.0
system.threading.tasks.extensions@4.5.4
"

inherit dotnet-pkg cmake

DESCRIPTION="DNCDbg is a managed code debugger with DAP support for .NET apps under the .NET Core runtime"
HOMEPAGE="https://github.com/Samsung/netcoredbg/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/viewizard/${PN}.git"
else
	SRC_URI="https://github.com/viewizard/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64"
fi

SRC_URI+="
	${NUGET_URIS}
"

LICENSE="MIT"
SLOT="0"

DOTNET_PKG_PROJECTS=(
	src/managed/ManagedPart.csproj   # Restore but do not build those projects.
)

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/disable-nuget-auditing.patch"
	"${FILESDIR}/fix-build-ninja.patch"
)

pkg_setup() {
	dotnet-pkg_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_configure() {
	INSTALL_PREFIX="/usr/$(get_libdir)/${PN}"
	dotnet-pkg_src_configure

	local -a mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
		-DDOTNET_DIR="${DOTNET_ROOT}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym -r "${INSTALL_PREFIX}/${PN}" "/usr/bin/${PN}"
	einstalldocs
}
