# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1

inherit kernel-build toolchain-funcs

if [[ ${PV} == *"_rc"* ]]; then
	BASE_P=linux-${PV/_/-}
else
	BASE_P=linux-$(ver_cut 1-2)
fi

# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
# forked to https://github.com/projg2/fedora-kernel-config-for-gentoo
CONFIG_VER=6.19.2-gentoo
GENTOO_CONFIG_VER=g18
SHA256SUM_DATE=20260217

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"

if [[ ${PV} == *"_rc"* ]]; then
	SRC_URI+="
		https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-${PV/_/-}.tar.gz
	"
elif [[ -n $(ver_cut 3) ]]; then
	SRC_URI+="
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PV}.xz
	"
else
	SRC_URI+="
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
	"
fi

SRC_URI+="
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	amd64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	arm64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-aarch64-fedora.config
			-> kernel-aarch64-fedora.config.${CONFIG_VER}
	)
	ppc64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-ppc64le-fedora.config
			-> kernel-ppc64le-fedora.config.${CONFIG_VER}
	)
	riscv? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-riscv64-fedora.config
			-> kernel-riscv64-fedora.config.${CONFIG_VER}
	)
	x86? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-i686-fedora.config
			-> kernel-i686-fedora.config.${CONFIG_VER}
	)
"

S=${WORKDIR}/${BASE_P}

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug hardened"
REQUIRED_USE="
	arm? ( savedconfig )
	hppa? ( savedconfig )
	sparc? ( savedconfig )
"

BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

src_prepare() {
	PATCHES=()
	if [[ -n $(ver_cut 3) && $(ver_cut 3) != "rc" ]]; then
		PATCHES+=( "${WORKDIR}/patch-${PV}" )
	fi

	PATCHES+=(
		"${FILESDIR}"/other/0008-Bluetooth-hci_qca-Drop-unused-event-during-BT-on.patch
		"${FILESDIR}"/other/0009-remove-werror-clang.patch
		"${FILESDIR}"/rockchip/0003-turing-rk1-dts-improve-fan-profile.patch
		"${FILESDIR}"/rockchip/0004-orangepi-5-plus-dts-add-bluetooth-rfkill.patch
		"${FILESDIR}"/rockchip/0005-orangepi-5-plus-dts-fix-rtc-clock-pullup.patch
		"${FILESDIR}"/rockchip/0006-orangepi-5-plus-dts-fix-led.patch
		"${FILESDIR}"/rockchip/0008-orangepi-5-plus-dts-dwc3-reset-quirk.patch
		"${FILESDIR}"/rockchip/0011-revert-add-npu-orangepi-5.patch
		"${FILESDIR}"/input/0003-hid-surfacego2-fix-touchcover.patch
		"${FILESDIR}"/camera/0017-surfacego2-camera.patch
	)

	default

	local biendian=false

	# prepare the default config
	case ${ARCH} in
		arm | hppa | loong | sparc)
			> .config || die
		;;
		amd64)
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		arm64)
			cp "${DISTDIR}/kernel-aarch64-fedora.config.${CONFIG_VER}" .config || die
			biendian=true
			;;
		ppc)
			# assume powermac/powerbook defconfig
			# we still package.use.force savedconfig
			cp "${WORKDIR}/${BASE_P}/arch/powerpc/configs/pmac32_defconfig" .config || die
			;;
		ppc64)
			cp "${DISTDIR}/kernel-ppc64le-fedora.config.${CONFIG_VER}" .config || die
			biendian=true
			;;
		riscv)
			cp "${DISTDIR}/kernel-riscv64-fedora.config.${CONFIG_VER}" .config || die
			;;
		x86)
			cp "${DISTDIR}/kernel-i686-fedora.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
		"${dist_conf_path}"/6.12+.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi

	# this covers ppc64 and aarch64_be only for now
	if [[ ${biendian} == true && $(tc-endian) == big ]]; then
		merge_configs+=( "${dist_conf_path}/big-endian.config" )
	fi

	use secureboot && merge_configs+=(
		"${dist_conf_path}/secureboot.config"
		"${dist_conf_path}/zboot.config"
	)

	kernel-build_merge_configs "${merge_configs[@]}"
}
