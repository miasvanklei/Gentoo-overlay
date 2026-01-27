# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd

DESCRIPTION="VS Code in the browser"
HOMEPAGE="https://coder.com/"

if [[ ${PV} == *rc* ]] ; then
	MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4)).$(ver_cut 5)"
else
	MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4))"
fi

# All binary packages depend on this
NAN_V=2.22.2

SRC_URI="
	https://github.com/nodejs/nan/archive/v${NAN_V}.tar.gz -> nodejs-nan-${NAN_V}.tar.gz
	https://github.com/cdr/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}-linux-amd64.tar.gz
"

COMPILE_VSCODE_BINMODS=(
	native-watchdog
	node-pty
	@vscode/spdlog
	@vscode/watcher
	argon2
)

CLEANUP_VSCODE_BINMODS=(
	"${COMPILE_VSCODE_BINMODS[@]}"
	@vscode/deviceid
	@vscode/windows-process-tree
	@vscode/windows-registry
	kerberos
)

S="${WORKDIR}/${PN}-${MY_PV}-linux-amd64"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

BDEPEND="
	app-misc/jq
"
RDEPEND="
	${DEPEND}
	net-libs/nodejs:0/22[npm,ssl]
	sys-apps/ripgrep
"

DOCS=( "README.md" "ThirdPartyNotices.txt" )

src_prepare() {
	# remove binaries from modules
	cleanup_binmods

	# prepare vscode modules for building
	for binmod in "${COMPILE_VSCODE_BINMODS[@]}"; do
		pkgdir="${WORKDIR}/$(package_dir ${binmod})"
		cp -r "$(get_binmod_loc ${binmod})" "${pkgdir}" || die
		mkdir -p "${pkgdir}/node_modules" || die
		ln -s "$(get_binmod_loc node-addon-api)" \
			"${pkgdir}/node_modules/node-addon-api" || die
		ln -s "${WORKDIR}/nan-${NAN_V}" \
			"${pkgdir}/node_modules/nan" || die
	done

	# not needed
	rm "${S}"/postinstall.sh || die

	# already in /usr/portage/licenses/MIT
	rm "${S}"/LICENSE || die

	jq -s add "${S}"/lib/vscode/product.json ${FILESDIR}/extensionGallery.json > "${S}"/lib/vscode/product.json.tmp || die
	mv "${S}"/lib/vscode/product.json.tmp "${S}"/lib/vscode/product.json

	eapply "${FILESDIR}/${PN}-node.patch"
	eapply_user
}

src_configure() {
	local binmod
	for binmod in "${COMPILE_VSCODE_BINMODS[@]}"; do
		einfo "Configuring ${binmod}..."
		cd "${WORKDIR}/$(package_dir ${binmod})" || die

		enodegyp configure
	done
}

src_compile() {
	local binmod
	local jobs=$(makeopts_jobs)
	local unpacked_paths

	for binmod in "${COMPILE_VSCODE_BINMODS[@]}"; do
		einfo "Building ${binmod}..."
		cd "${WORKDIR}/$(package_dir ${binmod})" || die
		enodegyp --verbose --jobs="$(makeopts_jobs)" build
		local install_path=$(get_binmod_loc_release ${binmod})
		cp "${WORKDIR}/$(package_dir ${binmod})/build/Release/"*.node ${install_path} || die
	done

	increase_reconnection_grace_time
}

src_install() {
	einstalldocs

	insinto "/usr/lib/${PN}"
	doins -r .
	fperms +x "/usr/lib/${PN}/bin/${PN}"
	dosym "../../usr/lib/${PN}/bin/${PN}" "${EPREFIX}/usr/bin/${PN}"

	dosym "/usr/bin/rg" "${EPREFIX}/usr/lib/${PN}/lib/vscode/node_modules/@vscode/ripgrep/bin/rg"

	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"
}

pkg_postinst() {
	elog "When using code-server systemd service run it as a user"
	elog "For example: 'systemctl --user enable --now code-server'"
}

# Increase ReconnectionGraceTime from 3h to 24h
increase_reconnection_grace_time() {
	local vscode_out_dir="/lib/vscode/out"
	local files=(
		"/vs/workbench/api/node/extensionHostProcess.js"
		"/vs/code/browser/workbench/workbench.js"
		"/server-main.js"
	)

	for file in "${files[@]}"; do
		sed -i -e "s|108e5|864e5|g" "${S}${vscode_out_dir}${file}" || die
	done
}

enodegyp() {
	local npmdir="${BROOT}/usr/lib/node_modules/npm"
	local nodegyp="${npmdir}/node_modules/node-gyp/bin/node-gyp.js"

	node "${nodegyp}" --nodedir="${BROOT}/usr/include/node" "${@}" || die
}

# Return a $WORKDIR directory for a given package name.
package_dir() {
	local binmod_n="${1//\//-}"
	binmod_n="${binmod_n//@/}"

	echo ${binmod_n}
}

# Some binmods have path that is different than usual
get_binmod_loc() {
	local binmod_path="${S}/lib/vscode/node_modules"
	if [[ "$1" == "argon2" ]]; then
		binmod_path="${S}/node_modules"
	fi
	echo "${binmod_path}/${1}"
}

# return and create binmod release path
get_binmod_loc_release() {
	local path="$(get_binmod_loc ${1})/build/Release"
	mkdir -p "$path"
	echo "$path"
}

# remove bundled binaries
cleanup_binmods() {
	# use system node
	rm ./lib/node || die "failed to remove bundled nodejs"

	for binmod in "${CLEANUP_VSCODE_BINMODS[@]}"; do
		rm -r "$(get_binmod_loc ${binmod})/build" || die
	done

	rm lib/vscode/node_modules/@vscode/ripgrep/bin/rg || die "failed to remove bundled ripgrep"

	# argon2 has prebuilds
	rm -r "${S}/node_modules/argon2/prebuilds" || die

	# remove microsoft authentication: not opensource, depends on webkitgtk, only available for x86_64
	local extensiondistdir="${S}/lib/vscode/extensions/microsoft-authentication/dist"
	rm -r "${extensiondistdir}/libmsalruntime.so" || die
	rm -r "${extensiondistdir}/msal-node-runtime.node" || die
}
