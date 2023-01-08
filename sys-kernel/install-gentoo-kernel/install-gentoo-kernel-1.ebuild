# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit mount-boot

KEYWORDS="~amd64 ~arm ~arm64"
SLOT=0
IUSE="efi extlinux"
REQUIRED_USE="|| ( efi extlinux )"

DESCRIPTION="install linux kernel to /boot"

BDEPEND="sys-kernel/gentoo-kernel:="

pkg_pretend() {
	mount-boot_pkg_pretend
}

pkg_preinst() {
	:
}

copy_kernel()
{
	local kernel_nonstripped=$(readlink /usr/src/linux)
	local kernel_version="${kernel_nonstripped#*-}"

	ebegin "Installing kernel with version ${kernel_version} to /boot/$1"

	# get version of current linux
	cp "${EROOT}/boot/vmlinuz-${kernel_version}" "${EROOT}/boot/$1" || die

	if use arm || use arm64; then
		# install dtb file for board given in ${DTB_FILE}.
		if [[ -n ${DTB_FILE} ]]; then
			ebegin "Installing ${DTB_FILE} from kernel with version ${kernel_version} to /boot/$1"

			cp "${EROOT}/boot/dtbs/${kernel_version}/${DTB_FILE}" "${EROOT}/boot/${DTB_FILE}" \; || die

			eend ${?}
		else
			ewarn "no DTB file set, boot may not be functional"
		fi
	fi

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
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
