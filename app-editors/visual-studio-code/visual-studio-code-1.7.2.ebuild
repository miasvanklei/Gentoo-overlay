# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
BASE_URI="https://vscode-update.azurewebsites.net/${PV}"
SRC_URI="
	x86? ( ${BASE_URI}/linux-ia32/stable ->  ${P}-x86.tar.gz )
	amd64? ( ${BASE_URI}/linux-x64/stable -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror strip"

LICENSE="Microsoft"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	>=dev-util/electron-1.3.4
	x11-libs/cairo
	gnome-base/gconf
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
"

ARCH=$(uname -m)

[[ ${ARCH} == "x86_64" ]] && S="${WORKDIR}/VSCode-linux-x64"
[[ ${ARCH} != "x86_64" ]] && S="${WORKDIR}/VSCode-linux-ia32"

src_prepare()
{
	epatch ${FILESDIR}/system-electron.patch
}

src_install(){
	insinto "/opt/${PN}"
	doins -r resources/app
	doins -r bin
	dosym "/opt/${PN}/bin/code" "/usr/bin/visual-studio-code"
	make_wrapper "${PN}" "/opt/${PN}/bin/code"
	make_desktop_entry "${PN}" "Visual Studio Code" "${PN}" "Development;IDE"
	doicon ${FILESDIR}/${PN}.png
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
	chmod +x ${D}/opt/${PN}/bin/code
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
