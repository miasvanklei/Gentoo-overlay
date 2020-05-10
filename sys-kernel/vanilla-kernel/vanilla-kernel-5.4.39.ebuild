# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="39"

inherit kernel-2 mount-boot savedconfig toolchain-funcs
detect_version
detect_arch

KEYWORDS="~arm"
HOMEPAGE="https://www.kernel.org/"
IUSE="experimental"

DESCRIPTION="Linux kernel built from vanilla upstream sources"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

# install-DEPEND actually
RDEPEND="sys-apps/debianutils"

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
		zinstall

	save_config "${WORKDIR}"/build/.config

	# install only dtb file for board given in ${DTB_FILE}.
	if [[ -z ${DTB_FILE} ]]; then
		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
			INSTALL_PATH="${ED}"/usr/lib/kernel \
				dtbs_install
	else
		dodir /usr/lib/kernel/dtbs/${PV}-vanilla
		find "${WORKDIR}"/build/arch -name ${DTB_FILE} -exec cp {} "${ED}"/usr/lib/kernel/dtbs/${PV}-vanilla/ \; || die
	fi
}

pkg_preinst() {
	:
}

pkg_postinst() {
	mount-boot_pkg_preinst

	if [[ -z ${KINSTALL_PATH} ]]; then
		ebegin "Installing the kernel by installkernel"
		installkernel "${PV}" \
			"${EROOT}/usr/lib/kernel/vmlinuz-${PV}-vanilla" \
			"${EROOT}/usr/lib/kernel/System.map-${PV}-vanilla" || die
		eend ${?}
	else
		ebegin "Installing the kernel by copying"
		cp "${EROOT}/usr/lib/kernel/vmlinuz-${PV}-vanilla" ${KINSTALL_PATH} || die
		eend ${?}
	fi

	# install dtb file for board given in ${DTB_FILE}.
	if [[ -n ${DTB_FILE} ]]; then
		cp "${EROOT}"/usr/lib/kernel/dtbs/${PV}-vanilla/${DTB_FILE} /boot
	fi

	savedconfig_pkg_postinst
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
