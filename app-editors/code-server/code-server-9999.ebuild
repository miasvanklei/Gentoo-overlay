# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd git-r3

DESCRIPTION="VS Code in the browser"
HOMEPAGE="https://coder.com/"

RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="gnome-keyring"
EGIT_REPO_URI="https://github.com/coder/code-server.git"

DEPEND=""
RDEPEND="
        ${DEPEND}
        >=net-libs/nodejs-14.16.1:0/14[ssl]
        dev-go/cloud-agent
	sys-apps/yarn
	app-misc/jq
        sys-apps/ripgrep
        gnome-keyring? (
                app-crypt/libsecret
        )
"
# node, gulp => a mess
RESTRICT=network-sandbox

PATCHES=(
)

src_compile() {
	yarn install
	yarn build
	yarn build:vscode
	yarn release
	yarn release:standalone
}

src_install() {
	remove_unwanted_files

	# install
	insinto /usr/lib/${PN}
	doins -r release-standalone/*

	fperms +x "/usr/lib/${PN}/bin/${PN}"
	dosym "../../usr/lib/${PN}/bin/${PN}" "${EPREFIX}/usr/bin/${PN}"

	dosym "/usr/bin/rg" "${EPREFIX}/usr/lib/${PN}/vendor/modules/code-oss-dev/node_modules/vscode-ripgrep/bin/rg"
	dosym "/usr/bin/coder-cloud-agent" "${EPREFIX}/usr/lib/${PN}/lib/coder-cloud-agent"
	dosym "/usr/bin/node" "${EPREFIX}/usr/lib/${PN}/lib/node"

	systemd_douserunit "${FILESDIR}/${PN}.service"
}


remove_unwanted_files() {
	pushd ${S}/release-standalone >/dev/null

	# remove intermediates
	find . -name "obj.target" -exec rm -rf {} + || die
	rm -r node_modules/argon2/build-tmp-napi-v3 || die
	rm -r vendor/modules/code-oss-dev/node_modules/@parcel/watcher/prebuilds || die

	# remove electron, not used and is huge
	rm -r "vendor/modules/code-oss-dev/node_modules/electron" || die

        # not needed
        rm code-server || die
        rm postinstall.sh || die
	rm lib/node || die

	# use system
	rm vendor/modules/code-oss-dev/node_modules/vscode-ripgrep/bin/rg || die

        # already in /usr/portage/licenses/MIT
        rm LICENSE.txt || die

	popd >/dev/null
}
