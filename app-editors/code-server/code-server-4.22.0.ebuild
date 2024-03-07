# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd

DESCRIPTION="VS Code in the browser"
HOMEPAGE="https://coder.com/"

MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4))$(ver_cut 5)"
BASE_URI="https://github.com/cdr/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}-linux"

# All binary packages depend on this
NAN_V=2.19.0

NODE_ADDON_API_V=8.0.0
NATIVE_WATCHDOG_V=1.4.1
NODE_PTY_V=1.1.0-beta6
VSCODE_SPDLOG_V=0.15.0
ARGON2_V=0.31.1
PARCEL_WATCHER_V=2.1.0

SRC_URI="
	${BASE_URI}-amd64.tar.gz
        https://github.com/nodejs/nan/archive/v${NAN_V}.tar.gz -> nodejs-nan-${NAN_V}.tar.gz
        https://registry.npmjs.org/native-watchdog/-/native-watchdog-${NATIVE_WATCHDOG_V}.tgz -> vscodedep-native-watchdog-${NATIVE_WATCHDOG_V}.tar.gz
        https://registry.npmjs.org/node-pty/-/node-pty-${NODE_PTY_V}.tgz -> vscodedep-node-pty-${NODE_PTY_V}.tar.gz
        https://registry.npmjs.org/@vscode/spdlog/-/spdlog-${VSCODE_SPDLOG_V}.tgz -> vscodedep-vscode-spdlog-${VSCODE_SPDLOG_V}.tar.gz
        https://registry.npmjs.org/@parcel/watcher/-/watcher-${PARCEL_WATCHER_V}.tgz -> vscodedep-parcel-watcher-${PARCEL_WATCHER_V}.tar.gz
        https://registry.npmjs.org/node-addon-api/-/node-addon-api-${NODE_ADDON_API_V}.tgz -> vscodedep-node-addon-api-${NODE_ADDON_API_V}.tar.gz
	https://registry.npmjs.org/argon2/-/argon2-${ARGON2_V}.tgz -> vscodedep-argon2-${ARGON2_V}.tar.gz
"

REBUILD_VSCODE_BINMODS=(
        native-watchdog
        node-pty
        @vscode/spdlog
)

COMPILE_VSCODE_BINMODS=(
        "${REBUILD_VSCODE_BINMODS[@]}"
	@parcel/watcher
)

PREPARE_VSCODE_BINMODS=(
        "${COMPILE_VSCODE_BINMODS[@]}"
	argon2
)

CLEANUP_VSCODE_BINMODS=(
        "${REBUILD_VSCODE_BINMODS[@]}"
	@vscode/windows-process-tree
	@vscode/windows-registry
	kerberos
)


RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	>=net-libs/nodejs-18.17.1:0/18[ssl]
	sys-apps/ripgrep
"

S="${WORKDIR}/${PN}-${MY_PV}-linux-amd64"

DOCS=( "README.md" "ThirdPartyNotices.txt" )

src_unpack() {
	local a

	for a in ${A} ; do
		case "${a}" in
			*code-server*)
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
	# prepare vscode modules for building
	for binmod in "${PREPARE_VSCODE_BINMODS[@]}"; do
		pkgdir="${WORKDIR}/$(package_dir ${binmod})"
		mkdir -p "${pkgdir}/node_modules" || die
		ln -s "${WORKDIR}/node-addon-api-${NODE_ADDON_API_V}" \
			"${pkgdir}/node_modules/node-addon-api" || die
		ln -s "${WORKDIR}/nodejs-nan-${NAN_V}" \
			"${pkgdir}/node_modules/nan" || die
	done

	# remove binaries from modules
	cleanup_binmods

	# remove broken symlinks
	rm -r lib/vscode/extensions/node_modules/.bin || die

	# not needed
	rm ${S}/postinstall.sh || die

	# already in /usr/portage/licenses/MIT
	rm ${S}/LICENSE || die

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

	# argon2
	einfo "rebuilding argon2..."
	enodepregyp rebuild -C "${WORKDIR}/$(package_dir argon2)"
	cp "${WORKDIR}/$(package_dir argon2)/lib/binding/napi-v3/argon2.node" "${S}/node_modules/argon2/lib/binding/napi-v3/argon2.node"
}

src_install() {
	einstalldocs

	insinto "/usr/lib/${PN}"
	doins -r .
	fperms +x "/usr/lib/${PN}/bin/${PN}"
	dosym "../../usr/lib/${PN}/bin/${PN}" "${EPREFIX}/usr/bin/${PN}"


	dosym "/usr/bin/rg" "${EPREFIX}/usr/lib/${PN}/lib/vscode/node_modules/@vscode/ripgrep/bin/rg"

	systemd_dounit "${FILESDIR}/${PN}@.service"
}

pkg_postinst() {
	elog "When using code-server systemd service run it as a user"
	elog "For example: 'systemctl --user enable --now code-server'"
}

enodepregyp() {
	"${S}"/node_modules/.bin/node-pre-gyp --nodedir="${BROOT}/usr/include/node" "${@}"
}

enodegyp() {
	local npmdir="${BROOT}/usr/lib/node_modules/npm"
	local nodegyp="${npmdir}/node_modules/node-gyp/bin/node-gyp.js"

	node "${nodegyp}" --nodedir="${BROOT}/usr/include/node" "${@}"
}

# Return a $WORKDIR directory for a given package name.
package_dir() {
	local binmod_n="${1//\//-}"
	binmod_n="${binmod_n//@/}"
	binmod="${binmod_n//-/_}"
	local binmod_v="${binmod^^}_V"
	if [[ -z "${binmod_v}" ]]; then
		die "${binmod_v} is not set."
	fi

	echo ${binmod_n}-${!binmod_v}
}

# Some binmods have path that is different than usual
get_binmod_loc() {
	echo "${S}/lib/vscode/node_modules/${1}"
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

	# remove argon2 & parcel-watcher
	rm -r "$(get_binmod_loc @parcel/watcher)/prebuilds" || die
	rm -r "${S}/node_modules/argon2/lib/binding/napi-v3/argon2.node" || die

}
