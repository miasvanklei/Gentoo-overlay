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
	x11-libs/libXtst
	=net-libs/nodejs-6.3.0
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
"

ARCH=$(uname -m)

[[ ${ARCH} == "x86_64" ]] && S="${WORKDIR}/VSCode-linux-x64"
[[ ${ARCH} != "x86_64" ]] && S="${WORKDIR}/VSCode-linux-ia32"


node_compile()
{
	npm install $@ --nodedir=/usr/include/electron/node || die
}

src_compile()
{
        elog "recompile node modules with binaries"
	node_compile native-keymap
	node_compile gc-signals
	node_compile oniguruma
	node_compile pty.js

        rm -r resources/app/node_modules/{native-keymap,gc-signals,oniguruma,pty.js} || die
        find node_modules/* -name "*obj.target*" -exec rm -r "{}" \;
        cp -r node_modules/* resources/app/node_modules || die
}

src_install(){
	insinto "/opt/${PN}"
	doins -r resources/app
        dobin ${FILESDIR}/vscode
	insinto "/usr/share/applications"
        doins ${FILESDIR}/vscode.desktop
	doicon ${FILESDIR}/vscode.png
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
