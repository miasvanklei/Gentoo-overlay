# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

DESCRIPTION="Symlinks to use Flang on gfortran-free system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="multilib-symlinks +native-symlinks"

RDEPEND="
	sys-devel/lld:${SLOT}
"

S=${WORKDIR}

src_install() {
	use native-symlinks || return

	local chosts=( "${CHOST}" )
	if use multilib-symlinks; then
		local abi
		for abi in $(get_all_abis); do
			chosts+=( "$(get_abi_CHOST "${abi}")" )
		done
	fi

	local dest=/usr/lib/llvm/${SLOT}/bin
	dodir "${dest}"
	dosym flang-new "${dest}/flang"
	dosym flang-new "${dest}/flang"
	for chost in "${chosts[@]}"; do
		dosym flang-new "${dest}/${chost}-flang"
		dosym flang-new "${dest}/${chost}-gfortran"
	done
}
