# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd

DESCRIPTION="VS Code in the browser"
HOMEPAGE="https://coder.com/"

BASE_URI="https://github.com/cdr/${PN}/releases/download/v${PV}/${P}-linux"

ASAR_V=0.14.3
# All binary packages depend on this
NAN_V=2.14.0

NODE_ADDON_API_V=3.1.0
NATIVE_WATCHDOG_V=1.3.0
NODE_PTY_V=0.11.0-beta11
SPDLOG_V=0.13.5
ARGON2_V=0.28.2
PARCEL_WATCHER_V=2.0.5

SRC_URI="
	${BASE_URI}-amd64.tar.gz
        https://github.com/elprans/asar/releases/download/v${ASAR_V}-gentoo/asar-build.tar.gz -> asar-${ASAR_V}.tar.gz
        https://github.com/nodejs/nan/archive/v${NAN_V}.tar.gz -> nodejs-nan-${NAN_V}.tar.gz
        https://registry.npmjs.org/native-watchdog/-/native-watchdog-${NATIVE_WATCHDOG_V}.tgz -> vscodedep-native-watchdog-${NATIVE_WATCHDOG_V}.tar.gz
        https://registry.npmjs.org/node-pty/-/node-pty-${NODE_PTY_V}.tgz -> vscodedep-node-pty-${NODE_PTY_V}.tar.gz
        https://registry.npmjs.org/spdlog/-/spdlog-${SPDLOG_V}.tgz -> vscodedep-spdlog-${SPDLOG_V}.tar.gz
        https://registry.npmjs.org/@parcel/watcher/-/watcher-${PARCEL_WATCHER_V}.tgz -> vscodedep-parcel-watcher-${PARCEL_WATCHER_V}.tar.gz
        https://registry.npmjs.org/node-addon-api/-/node-addon-api-${NODE_ADDON_API_V}.tgz -> vscodedep-node-addon-api-${NODE_ADDON_API_V}.tar.gz
	https://registry.npmjs.org/argon2/-/argon2-${ARGON2_V}.tgz -> vscodedep-argon2-${ARGON2_V}.tar.gz
"

VSCODE_BINMODS=(
        native-watchdog
        node-pty
        spdlog
	parcel-watcher
)

RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome-keyring"

DEPEND=""
RDEPEND="
	${DEPEND}
	app-crypt/node-rs_argon2
	>=net-libs/nodejs-14.16.1:0/14[ssl]
	dev-go/cloud-agent
	sys-apps/ripgrep
	gnome-keyring? (
		app-crypt/libsecret
	)
"

S="${WORKDIR}/${P}-linux-amd64"

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

	# argon2
	pkgdir="${WORKDIR}/$(package_dir argon2)"
	mkdir -p "${pkgdir}/node_modules" || die
	ln -s "${WORKDIR}/node-addon-api-${NODE_ADDON_API_V}" \
		"${pkgdir}/node_modules/node-addon-api" || die
	ln -s "${WORKDIR}/nodejs-nan-${NAN_V}" \
		"${pkgdir}/node_modules/nan" || die
	eapply "${FILESDIR}/${PN}-node.patch"

        eapply_user

	# use system node
	rm ./node ./lib/node ./lib/vscode/node \
		|| die "failed to remove bundled nodejs"
	rm ./lib/coder-cloud-agent || die "failed to remove bundled coder-cloud-agent"

	# remove bundled binaries
	rm lib/vscode/node_modules/@vscode/ripgrep/bin/rg \
		|| die "failed to remove bundled ripgrep"
	for binmod in "${VSCODE_BINMODS[@]}"; do
		rm -r "$(get_binmod_loc_build ${binmod})" || die
	done

	# remove argon2
	rm -r "${S}/node_modules/argon2/build-tmp-napi-v3" || die

	# not needed
	rm ${S}/code-server || die
	rm ${S}/postinstall.sh || die

	# already in /usr/portage/licenses/MIT
	rm ${S}/LICENSE.txt || die
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
		cp -r "${WORKDIR}/$(package_dir ${binmod})/build/Release" ${install_path} || die
		rm -r ${install_path}/Release/obj.target || die
		rm -r ${install_path}/Release/.deps || die
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
	dosym "/usr/bin/coder-cloud-agent" "${EPREFIX}/usr/lib/${PN}/lib/coder-cloud-agent"

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
	local binmod="${1//-/_}"
	local binmod_v="${binmod^^}_V"
	if [[ -z "${binmod_v}" ]]; then
		die "${binmod_v} is not set."
	fi

	echo ${1}-${!binmod_v}
}

# Some binmods have path that is different than usual
get_binmod_loc() {
	if [ ${1} = "parcel-watcher" ]; then
		echo "${S}/lib/vscode/node_modules/@${1%-*}/${1#*-}"
	else
		echo "${S}/lib/vscode/node_modules/${1}"
	fi
}

# return binmod release path
get_binmod_loc_release() {
		local path="$(get_binmod_loc ${1})/build"
		mkdir -p "$path"
		echo "$path"
}

# return binmod build path
get_binmod_loc_build() {
	if [ ${1} = "parcel-watcher" ]; then
		echo "$(get_binmod_loc ${1})/prebuilds"
	else
		echo "$(get_binmod_loc ${1})/build"
	fi
}
