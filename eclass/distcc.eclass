# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: crossdev.eclass
# @MAINTAINER:
# mias van klei
# @AUTHOR:
# Mias van Klei (15 Sep 2023)
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Convenience wrappers for usage by distcc

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DISTCC_ECLASS} ]]; then
_DISTCC_ECLASS=1

RDEPEND="
        sys-devel/clang:${PV}
"

src_install() {
	local distcc_pn_prefix="distcc_"
	local distcc_target=${PN#${distcc_pn_prefix}}

	local llvm_path="${EPREFIX}/usr/lib/llvm/${SLOT}"
	into "${llvm_path}"

	local tools=(
		${distcc_target}-clang:${distcc_target}-clang-${SLOT}
		${distcc_target}-clang++:${distcc_target}-clang++-${SLOT}
		${distcc_target}-clang-${SLOT}:clang-${SLOT}
		${distcc_target}-clang++-${SLOT}:clang++-${SLOT}
		${distcc_target}-gcc:${distcc_target}-gcc-${SLOT}
		${distcc_target}-g++:${distcc_target}-g++-${SLOT}
		${distcc_target}-gcc-${SLOT}:clang-${SLOT}
		${distcc_target}-g++-${SLOT}:clang++-${SLOT}
	)

	local t
	for t in "${tools[@]}"; do
		dosym "${t#*:}" "${llvm_path}/bin/${t%:*}"
	done
}

fi
