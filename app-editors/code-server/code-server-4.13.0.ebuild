# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd

DESCRIPTION="VS Code in the browser"
HOMEPAGE="https://coder.com/"

BASE_URI="https://github.com/cdr/${PN}/releases/download/v${PV}/${P}-linux"

# All binary packages depend on this
NAN_V=2.14.0

NODE_ADDON_API_V=3.1.0
NATIVE_WATCHDOG_V=1.4.1
NODE_PTY_V=0.11.0-beta32
VSCODE_SPDLOG_V=0.13.9
ARGON2_V=0.30.3
PARCEL_WATCHER_V=2.1.0
KEYTAR_V=7.9.0

SRC_URI="
	${BASE_URI}-amd64.tar.gz
        https://github.com/nodejs/nan/archive/v${NAN_V}.tar.gz -> nodejs-nan-${NAN_V}.tar.gz
        https://registry.npmjs.org/native-watchdog/-/native-watchdog-${NATIVE_WATCHDOG_V}.tgz -> vscodedep-native-watchdog-${NATIVE_WATCHDOG_V}.tar.gz
        https://registry.npmjs.org/node-pty/-/node-pty-${NODE_PTY_V}.tgz -> vscodedep-node-pty-${NODE_PTY_V}.tar.gz
        https://registry.npmjs.org/@vscode/spdlog/-/spdlog-${VSCODE_SPDLOG_V}.tgz -> vscodedep-vscode-spdlog-${VSCODE_SPDLOG_V}.tar.gz
        https://registry.npmjs.org/@parcel/watcher/-/watcher-${PARCEL_WATCHER_V}.tgz -> vscodedep-parcel-watcher-${PARCEL_WATCHER_V}.tar.gz
        https://registry.npmjs.org/node-addon-api/-/node-addon-api-${NODE_ADDON_API_V}.tgz -> vscodedep-node-addon-api-${NODE_ADDON_API_V}.tar.gz
	https://registry.npmjs.org/argon2/-/argon2-${ARGON2_V}.tgz -> vscodedep-argon2-${ARGON2_V}.tar.gz
	https://registry.npmjs.org/keytar/-/keytar-${KEYTAR_V}.tgz -> vscodedep-keytar-${KEYTAR_V}.tar.gz
"

VSCODE_BINMODS=(
        native-watchdog
        node-pty
        @vscode/spdlog
	@parcel/watcher
	keytar
)

RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	app-crypt/node-rs_argon2
	>=net-libs/nodejs-16.14.2:0/16[ssl]
	sys-apps/ripgrep
	app-crypt/libsecret
"

S="${WORKDIR}/${P%_*}-linux-amd64"

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
	for binmod in "${VSCODE_BINMODS[@]}"; do
		pkgdir="${WORKDIR}/$(package_dir ${binmod})"
		mkdir -p "${pkgdir}/node_modules" || die
		ln -s "${WORKDIR}/node-addon-api-${NODE_ADDON_API_V}" \
			"${pkgdir}/node_modules/node-addon-api" || die
		ln -s "${WORKDIR}/nodejs-nan-${NAN_V}" \
			"${pkgdir}/node_modules/nan" || die
	done

	# argon2 prepare
	pkgdir="${WORKDIR}/$(package_dir argon2)"
	mkdir -p "${pkgdir}/node_modules" || die
	ln -s "${WORKDIR}/node-addon-api-${NODE_ADDON_API_V}" \
			"${pkgdir}/node_modules/node-addon-api" || die
	ln -s "${WORKDIR}/nodejs-nan-${NAN_V}" \
		"${pkgdir}/node_modules/nan" || die

	# fix use of lfs64* symbol
	pushd "${WORKDIR}/$(package_dir vscode-spdlog)" >/dev/null || die
	eapply "${FILESDIR}/${PN}-spdlog-lfs64.patch"
	popd

	eapply "${FILESDIR}/${PN}-node.patch"
        eapply_user

	# use system node
	rm ./lib/node || die "failed to remove bundled nodejs"

	# remove bundled binaries
	rm lib/vscode/node_modules/@vscode/ripgrep/bin/rg || die "failed to remove bundled ripgrep"
	for binmod in "${VSCODE_BINMODS[@]}"; do
		rm -r "$(get_binmod_loc ${binmod})/build" || die
	done

	# remove argon2 & parcel-watcher
	rm -r "$(get_binmod_loc @parcel/watcher)/prebuilds" || die
	rm -r "${S}/node_modules/argon2/build-tmp-napi-v3" || die
	rm -r "${S}/node_modules/argon2/lib/binding/napi-v3/argon2.node" || die

	# remove broken symlinks
	rm -r lib/vscode/extensions/node_modules/.bin || die

	# not needed
	rm ${S}/postinstall.sh || die

	# already in /usr/portage/licenses/MIT
	rm ${S}/LICENSE || die
}

src_configure() {
	local binmod

	for binmod in "${VSCODE_BINMODS[@]}"; do
		einfo "Configuring ${binmod}..."
		cd "${WORKDIR}/$(package_dir ${binmod})" || die

		enodegyp configure
	done
}

src_compile() {
	local binmod
	local jobs=$(makeopts_jobs)
	local unpacked_paths

	for binmod in "${VSCODE_BINMODS[@]}"; do
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

	systemd_douserunit "${FILESDIR}/${PN}.service"
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