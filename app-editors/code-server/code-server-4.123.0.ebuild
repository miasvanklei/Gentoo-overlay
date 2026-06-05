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
NAN_V=2.27.0
NODE_ADDON_API_V=8.8.0
VSCODE_NATIVE_WATCHDOG_V=1.4.6
NODE_PTY_V=1.2.0-beta.13
VSCODE_SPDLOG_V=0.15.8
VSCODE_SQLITE3_V=5.1.12-vscode
ARGON2_V=0.44.0
PARCEL_WATCHER_V=2.5.6
COPILOT_VERSION=1.0.49

SRC_URI="
	https://github.com/nodejs/nan/archive/v${NAN_V}.tar.gz -> nodejs-nan-${NAN_V}.tar.gz
	amd64? (
		https://github.com/cdr/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}-linux-amd64.tar.gz
		elibc_musl? (
			https://github.com/github/copilot-cli/releases/download/v${COPILOT_VERSION}/github-copilot-${COPILOT_VERSION}-linuxmusl-x64.tgz ->  github-copilot-linuxmusl-x64-${COPILOT_VERSION}.tgz
		)
		elibc_glibc? (
			https://github.com/github/copilot-cli/releases/download/v${COPILOT_VERSION}/github-copilot-${COPILOT_VERSION}-linux-x64.tgz ->  github-copilot-linux-x64-${COPILOT_VERSION}.tgz
		)
	)
	arm64? (
		https://github.com/cdr/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}-linux-arm64.tar.gz
		elibc_musl? (
			https://github.com/github/copilot-cli/releases/download/v${COPILOT_VERSION}/github-copilot-${COPILOT_VERSION}-linuxmusl-arm64.tgz ->  github-copilot-linuxmusl-arm64-${COPILOT_VERSION}.tgz
		)
		elibc_glibc? (
			https://github.com/github/copilot-cli/releases/download/v${COPILOT_VERSION}/github-copilot-${COPILOT_VERSION}-linux-arm64.tgz ->  github-copilot-linux-arm64-${COPILOT_VERSION}.tgz
		)
	)
	https://registry.npmjs.org/@vscode/native-watchdog/-/native-watchdog-${VSCODE_NATIVE_WATCHDOG_V}.tgz -> vscodedep-vscode-native-watchdog-${VSCODE_NATIVE_WATCHDOG_V}.tar.gz
	https://registry.npmjs.org/node-pty/-/node-pty-${NODE_PTY_V}.tgz -> vscodedep-node-pty-${NODE_PTY_V}.tar.gz
	https://registry.npmjs.org/@vscode/spdlog/-/spdlog-${VSCODE_SPDLOG_V}.tgz -> vscodedep-vscode-spdlog-${VSCODE_SPDLOG_V}.tar.gz
	https://registry.npmjs.org/@vscode/sqlite3/-/sqlite3-${VSCODE_SQLITE3_V}.tgz -> vscodedep-vscode-sqlite3-${VSCODE_SQLITE3_V}.tar.gz
	https://registry.npmjs.org/@parcel/watcher/-/watcher-${PARCEL_WATCHER_V}.tgz -> vscodedep-parcel-watcher-${PARCEL_WATCHER_V}.tar.gz
	https://registry.npmjs.org/node-addon-api/-/node-addon-api-${NODE_ADDON_API_V}.tgz -> vscodedep-node-addon-api-${NODE_ADDON_API_V}.tar.gz
	https://registry.npmjs.org/argon2/-/argon2-${ARGON2_V}.tgz -> vscodedep-argon2-${ARGON2_V}.tar.gz
"

PATCH_VSCODE_BINMODS=(
	@vscode/sqlite3
)

COMPILE_VSCODE_BINMODS=(
	"${PATCH_VSCODE_BINMODS[@]}"
	@vscode/native-watchdog
	node-pty
	@vscode/spdlog
	@parcel/watcher
	argon2
)

CLEANUP_VSCODE_BINMODS=(
	"${COMPILE_VSCODE_BINMODS[@]}"
	@vscode/deviceid
	kerberos
)


S="${WORKDIR}/${PN}-${MY_PV}-linux-$(tc-arch)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

BDEPEND="
	app-misc/jq
"
RDEPEND="
	${DEPEND}
	net-libs/nodejs:0/24[npm,ssl]
	sys-apps/ripgrep
"

DOCS=( "README.md" "ThirdPartyNotices.txt" )

src_unpack() {
	local a

	for a in ${A} ; do
		case "${a}" in
			*code-server*|*copilot*)
				unpack "${a}"
			;;

			*.tar|*.tar.gz|*.tar.bz2|*.tar.xz)
				# Tarballs on registry.npmjs.org are wildly inconsistent,
				# and violate the convention of having ${P} as the top
				# directory name, so we strip the first component and
				# unpack into a correct directory explicitly.
				local basename=${a%.tar.*}
				local destdir=${WORKDIR}/${basename#vscodedep-}
				mkdir "${destdir}" || die
				tar -C "${destdir}" -x -o --strip-components 1 \
					-f "${DISTDIR}/${a}" || die
				;;

			*)
				# Fallback to the default unpacker.
				unpack "${a}"
				;;
		esac
	done
}

src_prepare() {
	# remove binaries from modules
	cleanup_binmods

	# prepare vscode modules for building
	for binmod in "${COMPILE_VSCODE_BINMODS[@]}"; do
		pkgdir="$(package_dir ${binmod})"
		mkdir -p "${pkgdir}/node_modules" || die
		ln -s "${WORKDIR}/node-addon-api-${NODE_ADDON_API_V}" \
			"${pkgdir}/node_modules/node-addon-api" || die
		ln -s "${WORKDIR}/nodejs-nan-${NAN_V}" \
			"${pkgdir}/node_modules/nan" || die
	done

	for binmod in "${PATCH_VSCODE_BINMODS[@]}"; do
		pushd "$(package_dir ${binmod})" >/dev/null || die
		for i in ${FILESDIR}/"$(get_pkg_name ${binmod})"*.patch; do
			eapply $i
		done
		popd >/dev/null
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
		cd "$(package_dir ${binmod})" || die

		enodegyp configure
	done
}

src_compile() {
	local binmod
	local jobs=$(makeopts_jobs)
	local unpacked_paths

	for binmod in "${COMPILE_VSCODE_BINMODS[@]}"; do
		einfo "Building ${binmod}..."
		cd "$(package_dir ${binmod})" || die
		enodegyp --verbose --jobs="$(makeopts_jobs)" build
		local install_path=$(get_binmod_loc_release ${binmod})
		cp "$(package_dir ${binmod})/build/Release/"*.node ${install_path} || die
	done
}

src_install() {
	einstalldocs

	insinto "/usr/lib/${PN}"
	doins -r .

	setup_ripgrep
	setup_copilot

	fperms +x "/usr/lib/${PN}/bin/${PN}"
	dosym "../../usr/lib/${PN}/bin/${PN}" "${EPREFIX}/usr/bin/${PN}"


	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"
}

pkg_postinst() {
	elog "When using code-server systemd service run it as a user"
	elog "For example: 'systemctl --user enable --now code-server'"
}

setup_copilot() {
	if use elibc_musl; then
		copilot_libc="musl"
	fi
	if use arm64; then
		copilot_arch="arm64"
	elif use amd64; then
		copilot_arch="x64"
	fi

	local copilot_dir="${D}/usr/lib/code-server/lib/vscode/node_modules/@github/copilot"
	local copilot_bin_dir="linux${copilot_libc}-${copilot_arch}"

	rm -r "${copilot_dir}/prebuilds" || die
	mkdir -p "${copilot_dir}/prebuilds/${copilot_bin_dir}" || die
	cp "${WORKDIR}/package/prebuilds/${copilot_bin_dir}/runtime.node" "${copilot_dir}/prebuilds/${copilot_bin_dir}/runtime.node" || die
}

setup_ripgrep() {
	if use arm64; then
		rg_arch="arm64"
	elif use amd64; then
		rg_arch="x64"
	fi

	local sdk_rg_dir="/usr/lib/${PN}/lib/vscode/extensions/copilot/node_modules/@github/copilot/sdk"
	rm -r "${D}/${sdk_rg_dir}/ripgrep/bin" || die
	dodir "${sdk_rg_dir}/ripgrep/bin/linux-${rg_arch}"
	dosym "/usr/bin/rg" "${EPREFIX}/${sdk_rg_dir}/ripgrep/bin/linux-${rg_arch}/rg"

	local rg_dir="/usr/lib/${PN}/lib/vscode/node_modules/@vscode/ripgrep-universal/bin/linux-${rg_arch}"
	rm "${D}/${rg_dir}/rg" || die "failed to remove bundled ripgrep"
	dosym "/usr/bin/rg" "${EPREFIX}/${rg_dir}/rg"
}

enodegyp() {
	local npmdir="${BROOT}/usr/lib/node_modules/npm"
	local nodegyp="${npmdir}/node_modules/node-gyp/bin/node-gyp.js"

	node "${nodegyp}" --nodedir="${BROOT}/usr/include/node" "${@}" || die
}

get_pkg_name() {
	local binmod_n="${1//\//-}"
	binmod_n="${binmod_n//@/}"

	echo ${binmod_n}
}

# Return a $WORKDIR directory for a given package name.
package_dir() {
	local binmod_n="$(get_pkg_name ${1})"
	binmod="${binmod_n//-/_}"
	local binmod_v="${binmod^^}_V"
	if [[ -z "${binmod_v}" ]]; then
		die "${binmod_v} is not set."
	fi

	echo "${WORKDIR}/${binmod_n}-${!binmod_v}"
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

	rm -r "${S}/lib/vscode/node_modules/@microsoft/mxc-sdk" || die

	for binmod in "${CLEANUP_VSCODE_BINMODS[@]}"; do
		rm -r "$(get_binmod_loc ${binmod})/build" || die
	done
}
