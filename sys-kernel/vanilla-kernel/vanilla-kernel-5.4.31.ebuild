# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot savedconfig toolchain-funcs

MY_PV="${PV/_/-}"
MY_P="linux-${MY_PV}"

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
#SRC_URI="https://git.kernel.org/torvalds/t/${MY_P}.tar.gz"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v5.x/${MY_P/.0}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="banana-pi"

# install-DEPEND actually
RDEPEND="sys-apps/debianutils"

S="${WORKDIR}/${MY_P/.0}"

pkg_pretend() {
	mount-boot_pkg_pretend
}

src_prepare() {
	eapply "${FILESDIR}"/banana-pi/wireguard-5.4.patch
	eapply "${FILESDIR}"/banana-pi/fix-wifi-bananapi.patch

	eapply_user
}

src_configure() {
	# is different than what linux kernel expects
	unset ARCH
	MAKEARGS=(
		# TODO: cross support
		HOSTCC="$(tc-getCC)"
		HOSTCXX="$(tc-getCXX)"
		HOSTCFLAGS="${CFLAGS}"
		HOSTLDFLAGS="${LDFLAGS}"

		AS="$(tc-getAS)"
		CC="$(tc-getCC) -w"
		LD="$(tc-getLD)"
		AR="$(tc-getAR)"
		NM="$(tc-getNM)"
		STRIP=":"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"
	)

	restore_config .config
	local target
	if [[ -f .config ]]; then
		mkdir -p "${WORKDIR}"/build || die
		mv .config "${WORKDIR}"/build/ || die
		target=olddefconfig
	else
		target=defconfig
	fi

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" "${target}"
}

src_compile() {
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" all
}

src_test() {
	:
}

src_install() {
	dodir /usr/lib/kernel
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_PATH="${ED}"/usr/lib/kernel \
		INSTALL_MOD_PATH="${ED}" \
		$(usex arm zinstall install)

	save_config "${WORKDIR}"/build/.config

	if use arm || use arm64; then
		# install only dtb file for board given in ${DTB_FILE}.
		if [[ -z ${DTB_FILE} ]]; then
				emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
					INSTALL_PATH="${ED}"/usr/lib/kernel \
					dtbs_install
		else
				dodir /usr/lib/kernel/dtbs/${MY_PV}
				find "${WORKDIR}"/build/arch -name ${DTB_FILE} -exec cp {} "${ED}"/usr/lib/kernel/dtbs/${MY_PV} \; || die
		fi
	fi
}

pkg_preinst() {
	:
}

pkg_postinst() {
	if [[ -z ${ROOT} ]]; then
		mount-boot_pkg_preinst

		if [[ -z ${KINSTALL_PATH} ]]; then
			ebegin "Installing the kernel by installkernel"
			installkernel "${PV}" \
				"${EROOT}/usr/lib/kernel/vmlinuz-${MY_PV}" \
				"${EROOT}/usr/lib/kernel/System.map-${MY_PV}" || die
			eend ${?}
		else
			ebegin "Installing the kernel by coping"
			cp "${EROOT}/usr/lib/kernel/vmlinuz-${MY_PV}" ${KINSTALL_PATH} || die
			eend ${?}
		fi

		if use arm || use arm64; then
			# install dtb file for board given in ${DTB_FILE}.
			if [[ -n ${DTB_FILE} ]]; then
				cp "${EROOT}"/usr/lib/kernel/dtbs/${MY_PV}/${DTB_FILE} /boot
			fi
		fi
	fi

	savedconfig_pkg_postinst
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
