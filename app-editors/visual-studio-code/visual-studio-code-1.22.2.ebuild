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

node_asar() {
        node_compile asar
	node_modules/asar/bin/asar.js extract resources/app/node_modules.asar resources/app/node_modules
	rm resources/app/node_modules.asar || die
	rm -r resources/app/node_modules.asar.unpacked || die
}

src_compile() {
	local n_p=(gc-signals@0.0.1 keytar@4.0.5 native-is-elevated@0.2.1 native-keymap@1.2.5 native-watchdog@0.3.0 node-pty@0.7.4 vscode-nsfw@1.0.17 oniguruma spdlog@0.6.0)
	for i in "${n_p[@]}"; do
		elog "recompiling $i"
		node_compile $i || die
		cp node_modules/${i%@*}/build/Release/*.node resources/app/node_modules.asar.unpacked/${i%@*}/build/Release/obj.target || die
		cp node_modules/${i%@*}/build/Release/*.node resources/app/node_modules.asar.unpacked/${i%@*}/build/Release/ || die
	done
	node_asar
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

	# fix permissions
	chmod +x ${D}/opt/visual-studio-code/app/node_modules/vscode-ripgrep/bin/rg || die

	# electron 1.6 does not have --inspect, use --debug instead
	grep -rl -- "--inspect=" ${D}/opt/visual-studio-code/app | xargs sed -i 's/--inspect=/--debug=/g'
}

pkg_postinst() {
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
