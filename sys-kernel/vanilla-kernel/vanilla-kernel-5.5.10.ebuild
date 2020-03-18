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
IUSE="allwinner banana-pi pine-h64 pinebook-pro"
REQUIRED_USE="
	pine-h64? ( allwinner )
	banana-pi? ( allwinner )"

# install-DEPEND actually
RDEPEND="sys-apps/debianutils"

S="${WORKDIR}/${MY_P/.0}"

pkg_pretend() {
	mount-boot_pkg_pretend
}

src_prepare() {
	if use pinebook-pro; then
		eapply "${FILESDIR}"/pinebook-pro/001-rk8xx-cleanup.patch
		eapply "${FILESDIR}"/pinebook-pro/002-add-cw2015.patch
		eapply "${FILESDIR}"/pinebook-pro/003-hdmi-codec.patch
		eapply "${FILESDIR}"/pinebook-pro/004-add-panel.patch
		eapply "${FILESDIR}"/pinebook-pro/006-usb-c.patch
		eapply "${FILESDIR}"/pinebook-pro/007-generic-fixes.patch
		eapply "${FILESDIR}"/pinebook-pro/008-add-cdn_dp-audio.patch
		eapply "${FILESDIR}"/pinebook-pro/009-pinebook-pro-dts.patch
		eapply "${FILESDIR}"/pinebook-pro/010-pinebook-pro-dts-makefile.patch
		eapply "${FILESDIR}"/pinebook-pro/011-revert-round-up-before-giving-to-the-clock-framework.patch
#		eapply "${FILESDIR}"/pinebook-pro/012-rk3399-gamma_support.patch
	fi

	if use allwinner; then

		eapply "${FILESDIR}"/allwinner/0001-backport-from-5.6.patch
		eapply "${FILESDIR}"/allwinner/0003-hdmi-improvements.patch
		eapply "${FILESDIR}"/allwinner/0004-sun4i-i2s-improvements.patch
		eapply "${FILESDIR}"/allwinner/0005-cedrus-improvements.patch
		eapply "${FILESDIR}"/allwinner/0006-wip-cec-improvements.patch
		eapply "${FILESDIR}"/allwinner/16-fix-de2-buggy-layer.patch
		eapply "${FILESDIR}"/allwinner/17-one-ui-plane-as-cursor.patch
	fi

	if use pine-h64; then
		eapply "${FILESDIR}"/pine-h64/0018-pine-add-cpu-supply-regulator.patch
		eapply "${FILESDIR}"/pine-h64/0019-h6-add-cpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0020-h6-add-gpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0022-add-support-for-rtl8723cs_bs.patch
		eapply "${FILESDIR}"/pine-h64/03-pineh64-enable-usb3.patch
		eapply "${FILESDIR}"/pine-h64/05-sound-hack.patch
		eapply "${FILESDIR}"/pine-h64/13-h6-add-ext_rmii_pins.patch
		eapply "${FILESDIR}"/pine-h64/14-eMMC-workaround.patch
		eapply "${FILESDIR}"/pine-h64/15-RTC-workaround.patch
	fi

	if use banana-pi; then
		eapply "${FILESDIR}"/banana-pi/fix-wifi-bananapi.patch
	fi

	if use arm64; then
		eapply "${FILESDIR}"/arm64/fix-macro-name.patch
	fi

	if use arm; then
		eapply "${FILESDIR}"/arm/warn-on-pre-ual-assembler-syntax.patch
		eapply "${FILESDIR}"/arm/use-fpu-directives-instead-of-assem-arguments.patch
		eapply "${FILESDIR}"/arm/use-vfp-assembler-mnemonics.patch
		eapply "${FILESDIR}"/arm/use-vfp-assembler-mnemonics-1.patch
	fi

	if use arm64 || use arm; then
		eapply "${FILESDIR}"/integrated-as.patch
	fi

	if use pinebook-pro || use pine-h64; then
		eapply "${FILESDIR}"/mmu-context-lifetime-not-bount-to_panfrost_priv.patch
		eapply "${FILESDIR}"/panfrost-make-purging-debug.patch
	fi

	eapply "${FILESDIR}"/wireguard.patch

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
		$(usex arm zinstall install) modules_install

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

	# become invalid so delete
	rm ${ED}/lib/modules/${MY_PV}/build
	rm ${ED}/lib/modules/${MY_PV}/source
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