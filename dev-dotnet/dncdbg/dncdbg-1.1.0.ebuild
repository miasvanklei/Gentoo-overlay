# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="DNCDbg is a managed code debugger with DAP support for .NET apps under the .NET Core runtime"
HOMEPAGE="https://github.com/viewizard/dncdbg"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/viewizard/${PN}.git"
else
	SRC_URI="https://github.com/viewizard/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( README.md )

src_configure() {
	INSTALL_PREFIX="/usr/$(get_libdir)/${PN}"

	local -a mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym -r "${INSTALL_PREFIX}/${PN}" "/usr/bin/${PN}"
	einstalldocs
}
