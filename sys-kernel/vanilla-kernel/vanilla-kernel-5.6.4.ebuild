# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="7"

inherit kernel-2 mount-boot savedconfig toolchain-funcs
detect_version
detect_arch

KEYWORDS="~amd64 ~arm ~arm64"
HOMEPAGE="https://www.kernel.org/"
IUSE="experimental pine-h64 pinebook-pro"

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
		eapply "${FILESDIR}"/pinebook-pro/001-rk8xx-cleanup.patch
		eapply "${FILESDIR}"/pinebook-pro/002-add-cw2015.patch
		eapply "${FILESDIR}"/pinebook-pro/006-usb-c.patch
		eapply "${FILESDIR}"/pinebook-pro/007-generic-fixes.patch
		eapply "${FILESDIR}"/pinebook-pro/008-add-cdn_dp-audio.patch
		eapply "${FILESDIR}"/pinebook-pro/009-pinebook-pro-dts.patch
		eapply "${FILESDIR}"/pinebook-pro/010-pinebook-pro-dts-makefile.patch
		eapply "${FILESDIR}"/pinebook-pro/011-revert-round-up-before-giving-to-the-clock-framework.patch
		eapply "${FILESDIR}"/pinebook-pro/012-rk3399-gamma_support.patch
	fi

	if use pine-h64; then
		eapply "${FILESDIR}"/pine-h64/0003-hdmi-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0004-sun4i-i2s-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0005-cedrus-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0006-wip-cec-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0018-pine-add-cpu-supply-regulator.patch
		eapply "${FILESDIR}"/pine-h64/0019-h6-add-cpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0020-h6-add-gpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0022-add-support-for-rtl8723cs_bs.patch
		eapply "${FILESDIR}"/pine-h64/03-pineh64-enable-usb3.patch
		eapply "${FILESDIR}"/pine-h64/05-sound-hack.patch
		eapply "${FILESDIR}"/pine-h64/13-h6-add-ext_rmii_pins.patch
		eapply "${FILESDIR}"/pine-h64/14-eMMC-workaround.patch
		eapply "${FILESDIR}"/pine-h64/15-RTC-workaround.patch
		eapply "${FILESDIR}"/pine-h64/16-fix-de2-buggy-layer.patch
		eapply "${FILESDIR}"/pine-h64/17-one-ui-plane-as-cursor.patch
	fi

	if use arm64; then
		eapply "${FILESDIR}"/pinebook-pro/003-hdmi-codec.patch
		eapply "${FILESDIR}"/integrated-as.patch
	fi

	if use pinebook-pro || use pine-h64; then
		eapply "${FILESDIR}"/mmu-context-lifetime-not-bount-to_panfrost_priv.patch
		eapply "${FILESDIR}"/panfrost-make-purging-debug.patch
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
		install

	save_config "${WORKDIR}"/build/.config

	if use arm64; then
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

		if use arm64; then
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
