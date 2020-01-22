# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot savedconfig toolchain-funcs

MY_P=linux-${PV/_/-}
DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://git.kernel.org/torvalds/t/${MY_P}.tar.gz"
#SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v5.x/${MY_P}.tar.xz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="banana-pi pine-h64 pine-book-pro"

# install-DEPEND actually
RDEPEND="sys-apps/debianutils"

pkg_pretend() {
	mount-boot_pkg_pretend
}

src_prepare() {
	if use pine-book-pro; then
		eapply "${FILESDIR}"/pine-book-pro/01-rk8xx-cleanup.patch
		eapply "${FILESDIR}"/pine-book-pro/02-add-cw2015.patch
		eapply "${FILESDIR}"/pine-book-pro/04-pinebook-pro.patch
		eapply "${FILESDIR}"/pine-book-pro/18-add-spk-mut-gpio.patch
	fi

	if use pine-h64; then
		eapply "${FILESDIR}"/pine-h64/0004-sun4i-i2s-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0005-cedrus-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0006-wip-cec-improvements.patch
		eapply "${FILESDIR}"/pine-h64/0013-force-full-range.patch
		eapply "${FILESDIR}"/pine-h64/0015-h6-add-thermal-driver.patch
		eapply "${FILESDIR}"/pine-h64/0016-h6-add-thermal-sensor-and-thermal-zones.patch
		eapply "${FILESDIR}"/pine-h64/0017-h6-add-thermal-trip-points_cooling-maps.patch
		eapply "${FILESDIR}"/pine-h64/0018-pine-add-cpu-supply-regulator.patch
		eapply "${FILESDIR}"/pine-h64/0019-h6-add-cpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0021-h6-add-gpu-opp-table.patch
		eapply "${FILESDIR}"/pine-h64/0022-add-support-for-rtl8723cs_bs.patch
		eapply "${FILESDIR}"/pine-h64/03-pineh64-enable-usb3.patch
		eapply "${FILESDIR}"/pine-h64/05-sound-hack.patch
		eapply "${FILESDIR}"/pine-h64/06-10-bit-HEVC-hack.patch
		eapply "${FILESDIR}"/pine-h64/11-pwm.patch
		eapply "${FILESDIR}"/pine-h64/13-h6-add-ext_rmii_pins.patch
		eapply "${FILESDIR}"/pine-h64/15-RTC-workaround.patch
		eapply "${FILESDIR}"/pine-h64/16-fix-de2-buggy-layer.patch
		eapply "${FILESDIR}"/pine-h64/17-one-ui-plane-as-cursor.patch
	fi

	if use banana-pi; then
		eapply "${FILESDIR}"/fix-wifi-bananapi.patch
	fi

	if use arm64; then
		eapply "${FILESDIR}"/0023-panfrost-fixes.patch
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
				dodir /usr/lib/kernel/dtbs/${PV}
				find "${WORKDIR}"/build/arch -name ${DTB_FILE} -exec cp {} "${ED}"/usr/lib/kernel/dtbs/${PV} \; || die
		fi
	fi

	# become invalid so delete
	rm ${ED}/lib/modules/${PV}/build || die
	rm ${ED}/lib/modules/${PV}/source || die
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
				"${EROOT}/usr/lib/kernel/vmlinuz-${PV}" \
				"${EROOT}/usr/lib/kernel/System.map-${PV}" || die
			eend ${?}
		else
			ebegin "Installing the kernel by coping"
			cp "${EROOT}/usr/lib/kernel/vmlinuz-${PV}" ${KINSTALL_PATH} || die
			eend ${?}
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