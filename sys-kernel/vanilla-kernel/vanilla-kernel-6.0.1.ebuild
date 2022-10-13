# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="2"

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
		eapply "${FILESDIR}"/panfrost-make-purging-debug.patch
		eapply "${FILESDIR}"/pinebook-pro/0001-pinebook-pro-dts.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/001-disable-cdn-dp-on-disconnect.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/003-inno-usb2-improvements.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/004-dwc3-improvements.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/005-fusb302-improvements.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/006-add-typec-extcon-bridge-driver.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/007-make-tcpm-logs-less-polluted.patch
		eapply "${FILESDIR}"/pinebook-pro/usb/008-pinebook-pro-dts-improvements.patch
		eapply "${FILESDIR}"/pinebook-pro/0007-drm-rockchip-support-gamma-control-on-RK3399.patch
		eapply "${FILESDIR}"/pinebook-pro/0008-add-cdn_dp-audio.patch
		eapply "${FILESDIR}"/pinebook-pro/0009-generic-fixes.patch
	fi

	use banana-pi && eapply "${FILESDIR}"/banana-pi/fix-wifi-bananapi.patch

	eapply_user
}

src_configure() {
	MAKEARGS=(
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
		LLVM=1
		LLVM_IAS=1
		ARCH=$(tc-arch-kernel)
	)

	restore_config .config
	mkdir -p "${WORKDIR}"/modprep || die
	mv .config "${WORKDIR}"/modprep/ || die
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" olddefconfig

	if grep -q "CONFIG_MODULES=y" "${WORKDIR}"/modprep/.config; then
		emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" modules_prepare
	fi


	cp -pR "${WORKDIR}"/modprep "${WORKDIR}"/build || die
}

src_compile() {
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" all
}

src_test() {
	:
}

src_install() {
	local kern_arch=$(tc-arch-kernel)
	local ver="${PV}${KV_LOCALVERSION}-vanilla"
	local targets=( )
	dodir "/usr/src/linux-${ver}/arch/${kern_arch}"

	# install target is named differently on arm
	if use arm; then
		targets+=( zinstall )
	else
		targets+=( install )
	fi

	if grep -q "CONFIG_MODULES=y" "${WORKDIR}"/build/.config; then
		targets+=( modules_install )
	fi

	# on arm or arm64 you also need dtb
	if use arm || use arm64; then
		targets+=( dtbs_install )
	fi

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${ED}" INSTALL_PATH="${ED}"/usr/src/linux-${ver} "${targets[@]}"
	rename -- "-${ver}" "" "${ED}"/usr/src/linux-${ver}/* || die

	# note: we're using mv rather than doins to save space and time
	# install main and arch-specific headers first, and scripts
	mv include scripts "${ED}/usr/src/linux-${ver}/" || die
	mv "arch/${kern_arch}/include" \
		"${ED}/usr/src/linux-${ver}/arch/${kern_arch}/" || die
	# some arches need module.lds linker script to build external modules
	if [[ -f arch/${kern_arch}/kernel/module.lds ]]; then
		insinto "/usr/src/linux-${ver}/arch/${kern_arch}/kernel"
		doins "arch/${kern_arch}/kernel/module.lds"
	fi

	# remove everything but Makefile* and Kconfig*
	find -type f '!' '(' -name 'Makefile*' -o -name 'Kconfig*' ')' -delete || die
	find -type l -delete || die
	cp -p -R * "${ED}/usr/src/linux-${ver}/" || die

	cd "${WORKDIR}" || die
	# strip out-of-source build stuffs from modprep
	# and then copy built files as well
	find modprep -type f '(' \
			-name Makefile -o \
			-name '*.[ao]' -o \
			'(' -name '.*' -a -not -name '.config' ')' \
			')' -delete || die
	rm modprep/source || die
	cp -p -R modprep/. "${ED}/usr/src/linux-${ver}"/ || die

	# strip empty directories
	find "${D}" -type d -empty -exec rmdir {} + || die

	# fix source tree and build dir symlinks
	dosym ../../../usr/src/linux-${ver} /lib/modules/${ver}/build
	dosym ../../../usr/src/linux-${ver} /lib/modules/${ver}/source

	save_config build/.config
}

pkg_preinst() {
	:
}

pkg_postinst() {
	mount-boot_pkg_preinst

	local ver="${PV}${KV_LOCALVERSION}-vanilla"

	if [[ -z ${KINSTALL_PATH} ]]; then
		ebegin "Installing the kernel by installkernel"
		installkernel "${PV}" \
			"${EROOT}/usr/src/linux-${ver}/vmlinuz" \
			"${EROOT}/usr/src/linux-${ver}/System.map" || die
		eend ${?}
	else
		ebegin "Installing the kernel by copying"
		cp "${EROOT}/usr/src/linux-${ver}/vmlinuz" ${KINSTALL_PATH} || die
		eend ${?}
	fi

	if use arm || use arm64; then
		# install dtb file for board given in ${DTB_FILE}.
		if [[ -n ${DTB_FILE} ]]; then
			find "${EROOT}"/usr/src/linux-${ver}/dtbs -name ${DTB_FILE} -exec cp {} /boot \; || die
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
