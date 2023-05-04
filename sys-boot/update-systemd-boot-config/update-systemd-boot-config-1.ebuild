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

create_systemd_boot_entry() {
	local kernel_version=${kernel#*-}

	cat <<- _EOF_ > ${S}/entries/gentoo-${kernel_version}.conf
		title Gentoo Linux ($kernel_version)
		linux /${kernel}
		options ${boot_args}
	_EOF_
}

create_systemd_boot_entries() {
	mkdir ${S}/entries || die
	for kernel in ${kernels[@]}; do
		local kernel=$(basename ${kernel})
		create_systemd_boot_entry
	done
}

create_systemd_boot_config()
{
	local root_partuuid=$(findmnt -fn -o PARTUUID /)
	local boot_args="root=PARTUUID=${root_partuuid} quiet loglevel=0 vt.global_cursor_default=0 usbcore.autosuspend=-1"
        local kernels=($(ls /boot/vmlinuz* | sort -Vr))
	local default_kernel_version=${kernels[0]#*-}

	cat <<- _EOF_ > ${S}/loader.conf
		default gentoo-${default_kernel_version%.old*}.conf
	_EOF_

	create_systemd_boot_entries
}

src_unpack() {
	mkdir ${WORKDIR}/${P} || die
}


src_compile() {
	create_systemd_boot_config
}

pkg_postinst() {
	cp ${S}/loader.conf /boot/loader/loader.conf
	cp ${S}/entries/*.conf /boot/loader/entries/
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
