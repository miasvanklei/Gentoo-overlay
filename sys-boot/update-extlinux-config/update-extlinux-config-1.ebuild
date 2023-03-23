# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit mount-boot

KEYWORDS="~amd64 ~arm ~arm64"
SLOT=0
IUSE=""

DESCRIPTION="install linux kernel to /boot"

BDEPEND="sys-kernel/gentoo-kernel:="

pkg_pretend() {
	mount-boot_pkg_pretend
}

pkg_preinst() {
	:
}

add_extlinux_entry() {
	local kernel_version=$1

	cat <<- _EOF_ >> ${S}/extlinux.conf

		LABEL Gentoo (${kernel})
		        MENU LABEL Gentoo (${kernel})
		        LINUX /${kernel}
		        FDTDIR /dtbs/${kernel/#vmlinuz-}
		        APPEND root=/dev/mmcblk0p2 ro
	_EOF_
}

add_extlinux_entries() {
	local kernels=(/boot/vmlinuz-*)

	for ((i=${#kernels[@]}-1; i>=0; i--)); do
		local kernel_path=${kernels[$i]}
		local kernel=$(basename ${kernel_path})
		add_extlinux_entry ${kernel}
	done
}

create_extlinux_config()
{
	cat <<- _EOF_ > ${S}/extlinux.conf
		MENU TITLE Boot menu
		TIMEOUT 3
	_EOF_

	add_extlinux_entries
}

src_unpack() {
	mkdir ${WORKDIR}/${P}
}


src_compile() {
	create_extlinux_config
}

pkg_postinst() {
	cp ${S}/extlinux.conf /boot/extlinux/
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
