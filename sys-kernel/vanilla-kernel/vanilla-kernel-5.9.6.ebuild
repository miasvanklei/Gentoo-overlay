
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="6"
K_NODRYRUN="1"

inherit kernel-2 mount-boot savedconfig toolchain-funcs
detect_version
detect_arch

KEYWORDS="~amd64 ~arm ~arm64"
HOMEPAGE="https://www.kernel.org/"
IUSE="experimental banana-pi pine-h64 pinebook-pro"

DESCRIPTION="Linux kernel built from vanilla upstream sources"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

# install-DEPEND actually
RDEPEND="sys-apps/debianutils"

pkg_pretend() {
	mount-boot_pkg_pretend
}

src_prepare() {
	if use pinebook-pro; then
		eapply "${FILESDIR}"/rockchip-increase-framebuffer-size.patch
		eapply "${FILESDIR}"/pinebook-pro/001-pinebook-pro-dts.patch
		eapply "${FILESDIR}"/pinebook-pro/002-add-cdn_dp-audio.patch
		eapply "${FILESDIR}"/pinebook-pro/003-usb-c.patch
		eapply "${FILESDIR}"/pinebook-pro/004-generic-fixes.patch
		eapply "${FILESDIR}"/pinebook-pro/005-revert-round-up-before-giving-to-the-clock-framework.patch
		eapply "${FILESDIR}"/pinebook-pro/006-rk3399-gamma_support.patch
	fi

	if use pine-h64; then
		eapply "${FILESDIR}"/pine-h64/001-h6-add-gpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/002-pineh64-enable-usb3.patch
		eapply "${FILESDIR}"/pine-h64/003-eMMC-workaround.patch
		eapply "${FILESDIR}"/pine-h64/004-add-support-for-rtl8723cs_bs.patch
		eapply "${FILESDIR}"/pine-h64/005-fix-ethernet.patch
		eapply "${FILESDIR}"/pine-h64/007-sun4i-i2s-improvements.patch
		eapply "${FILESDIR}"/pine-h64/008-cedrus-improvements.patch
		eapply "${FILESDIR}"/pine-h64/009-wip-cec-improvements.patch
		eapply "${FILESDIR}"/pine-h64/010-sound-hack.patch
		eapply "${FILESDIR}"/pine-h64/011-h6-add-ext_rmii_pins.patch
		eapply "${FILESDIR}"/pine-h64/012-fix-de2-buggy-layer.patch
		eapply "${FILESDIR}"/pine-h64/013-one-ui-plane-as-cursor.patch
	fi

	if use pinebook-pro || use pine-h64; then
		eapply "${FILESDIR}"/panfrost-make-purging-debug.patch
	fi

	if use banana-pi; then
		eapply "${FILESDIR}"/integrated-as.patch
		eapply "${FILESDIR}"/banana-pi/fix-wifi-bananapi.patch
	fi

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
		LLVM_IAS=1
		LLVM=1
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
	local target
	if use pine-h64; then
		target=(
			install
			modules_install
		)
	elif use banana-pi; then
		target=(
			zinstall
		)
	else
		target=(
			install
		)
	fi

	dodir /usr/lib/kernel
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_PATH="${ED}"/usr/lib/kernel \
		INSTALL_MOD_PATH="${ED}" \
		"${target[@]}"

	# remove unreachable folders
	if use pine-h64; then
		rm "${ED}"/lib/modules/${PV}-vanilla/build || die
		rm "${ED}"/lib/modules/${PV}-vanilla/source || die
	fi

	save_config "${WORKDIR}"/build/.config

	if use arm || use arm64; then
		# install only dtb file for board given in ${DTB_FILE}.
		if [[ -z ${DTB_FILE} ]]; then
			emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
				INSTALL_PATH="${ED}"/usr/lib/kernel \
				dtbs_install
		else
			dodir /usr/lib/kernel/dtbs/${PV}-vanilla
			find "${WORKDIR}"/build/arch -name ${DTB_FILE} -exec cp {} "${ED}"/usr/lib/kernel/dtbs/${PV}-vanilla/ \; || die
		fi
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

	if use arm || use arm64; then
		# install dtb file for board given in ${DTB_FILE}.
		if [[ -n ${DTB_FILE} ]]; then
			cp "${EROOT}"/usr/lib/kernel/dtbs/${PV}-vanilla/${DTB_FILE} /boot
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
