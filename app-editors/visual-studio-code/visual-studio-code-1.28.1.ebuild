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
	>=dev-util/electron-2.0.10
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
	npm install $@ --nodedir=/usr/include/electron-2.0/node || die
}


src_compile() {
	local n_p=(gc-signals@0.0.1 keytar@4.2.1 native-is-elevated@0.2.1 native-keymap@1.2.5 native-watchdog@1.0.0 node-pty@0.7.8 vscode-nsfw@1.1.1 oniguruma spdlog@0.7.2)
	for i in "${n_p[@]}"; do
		elog "recompiling $i"
		node_compile $i || die
		cp node_modules/${i%@*}/build/Release/*.node resources/app/node_modules.asar.unpacked/${i%@*}/build/Release/obj.target || die
		cp node_modules/${i%@*}/build/Release/*.node resources/app/node_modules.asar.unpacked/${i%@*}/build/Release/ || die
	done
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
	fperms +x "/opt/${PN}/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
}

pkg_postinst() {
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
