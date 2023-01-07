# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit mount-boot

KEYWORDS="~amd64 ~arm ~arm64"
SLOT=0
IUSE="efi extlinux"
REQUIRED_USE="|| ( efi extlinux )"

DESCRIPTION="install linux kernel to /boot"

BDEPEND="=sys-kernel/gentoo-kernel-${PV}"

pkg_pretend() {
	mount-boot_pkg_pretend
}

pkg_preinst() {
	:
}

copy_kernel()
{
	ebegin "Installing the kernel by copying to /boot/$1"
	cp "${EROOT}/boot/vmlinuz-${PV}" "${EROOT}/boot/$1" || die
	eend ${?}
}

pkg_postinst() {
	mount-boot_pkg_preinst

	if use extlinux; then
		copy_kernel "extlinux/vmlinuz"
	fi

	if use efi; then
		copy_kernel "EFI/GENTOO/vmlinuz.efi"
	fi

	if use arm || use arm64; then
		# install dtb file for board given in ${DTB_FILE}.
		if [[ -n ${DTB_FILE} ]]; then
			find "${EROOT}"/usr/src/linux/dtbs -name ${DTB_FILE} -exec cp {} /boot \; || die
		else
			ewarn "no DTB file set, boot may not be functional"
		fi
	fi
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
