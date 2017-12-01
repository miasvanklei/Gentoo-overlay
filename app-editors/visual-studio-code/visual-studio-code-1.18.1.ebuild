# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="https://vscode-update.azurewebsites.net/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz"
RESTRICT="mirror strip"

LICENSE="Microsoft"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	app-crypt/libsecret
	>=dev-util/electron-1.6.15
	x11-libs/cairo
	x11-libs/libXtst
	net-libs/nodejs
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
"

S="${WORKDIR}/VSCode-linux-x64"

node_compile() {
	npm install $@ --nodedir=/usr/include/electron-1.6/node || die
}

src_compile() {
	local n_p=(native-keymap native-watchdog gc-signals oniguruma node-pty keytar v8-profiler nsfw)
	for i in "${n_p[@]}"; do
		elog "recompiling $i"
		node_compile $i || die
		rm -r resources/app/node_modules/$i || die
	done

	elog "deleting object and dep files"
	find ${S} -name .deps -exec rm -rf "{}" \;
	find ${S} -name obj.target -exec rm -rf "{}" \;

	elog "copying node_modules"
        cp -r node_modules/* resources/app/node_modules || die
}

src_install() {
	insinto "/opt/${PN}"
	doins -r resources/app
        dobin ${FILESDIR}/vscode
	insinto "/usr/share/applications"
        doins ${FILESDIR}/vscode.desktop
	doicon ${FILESDIR}/vscode.png
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
}

pkg_postinst() {
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
