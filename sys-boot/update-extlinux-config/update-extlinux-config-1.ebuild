# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	cat <<- _EOF_ >> ${S}/extlinux.conf

		LABEL Gentoo (${kernel})
		        MENU LABEL Gentoo (${kernel})
		        LINUX /${kernel}
		        FDTDIR /dtbs/${kernel/#vmlinuz-}
		        APPEND ${boot_args}
	_EOF_
}

add_extlinux_entries() {
	local kernels=($(ls /boot/vmlinuz* | sort -Vr))
	local root_partuuid=$(findmnt -fn -o PARTUUID /)
	local boot_args="root=PARTUUID=${root_partuuid} rootwait quiet loglevel=0 vt.global_cursor_default=0 ${EXTRA_BOOT_ARGS}"

	for kernel in ${kernels[@]}; do
		local kernel=$(basename ${kernel})
		add_extlinux_entry ${kernel} ${boot_args}
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
