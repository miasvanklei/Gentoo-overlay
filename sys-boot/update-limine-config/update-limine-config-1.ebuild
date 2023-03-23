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

add_limine_entry() {
	local kernel_version=$1

	cat <<- _EOF_ >> ${S}/limine.cfg

		:Gentoo (${kernel})
		    PROTOCOL=linux
		    KERNEL_PATH=boot:///${kernel}
		    CMDLINE=\${BOOT_ARGS}
	_EOF_
}

add_limine_entries() {
	local kernels=(/boot/vmlinuz*)

	for ((i=${#kernels[@]}-1; i>=0; i--)); do
		local kernel_path=${kernels[$i]}
		local kernel=$(basename ${kernel_path})
		add_limine_entry ${kernel}
	done
}

create_limine_config()
{
	local root_partuuid=$(findmnt -fn -o PARTUUID /)

	cat <<- _EOF_ > ${S}/limine.cfg
		\${BOOT_ARGS}=root=PARTUUID=${root_partuuid} quiet loglevel=0 vt.global_cursor_default=0 usbcore.autosuspend=-1

		DEFAULT_ENTRY=1
		TIMEOUT=3
		VERBOSE=yes
	_EOF_

	add_limine_entries
}

src_unpack() {
	mkdir ${WORKDIR}/${P}
}


src_compile() {
	create_limine_config
}

pkg_postinst() {
	cp ${S}/limine.cfg /boot/EFI/BOOT
}

pkg_prerm() {
	:
}

pkg_postrm() {
	:
}
