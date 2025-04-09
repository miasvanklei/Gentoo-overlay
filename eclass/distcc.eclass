# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: distcc.eclass
# @MAINTAINER:
# mias van klei
# @AUTHOR:
# Mias van Klei (15 Sep 2023)
# @SUPPORTED_EAPIS: 8
# @BLURB: Convenience wrappers for usage by distcc

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DISTCC_ECLASS} ]]; then
_DISTCC_ECLASS=1

RDEPEND="
        llvm-core/clang:${PV}
"

doclang_runtime_cfg() {
	local triple="${1}"

	local tool
	for tool in ${triple}-clang{,++,-cpp}; do
		newins - "${tool}.cfg" <<-EOF
			# This configuration file is used by ${tool} driver.
			@../${tool}.cfg
			@gentoo-plugins.cfg
			@gentoo-runtimes.cfg
		EOF
	done

	# Install symlinks for triples with other vendor strings since some
	# programs insist on mangling the triple.
	local vendor
	for vendor in gentoo pc unknown; do
		local vendor_triple="${triple%%-*}-${vendor}-${triple#*-*-}"
		for tool in clang{,++,-cpp}; do
			if [[ ! -f "${ED}/etc/clang/${SLOT}/${vendor_triple}-${tool}.cfg" ]]; then
				dosym "${triple}-${tool}.cfg" "/etc/clang/${SLOT}/${vendor_triple}-${tool}.cfg"
			fi
		done
	done
}

doclang_common_cfg() {
	local triple="${1}"

	local tool
	for tool in ${triple}-clang{,++}; do
		newins - "${tool}.cfg" <<-EOF
			# This configuration file is used by ${tool} driver.
			@gentoo-common.cfg
			@gentoo-common-ld.cfg
			EOF
		if [[ ${triple} == x86_64* ]]; then
			cat >> "${ED}/etc/clang/${tool}.cfg" <<-EOF || die
			@gentoo-cet.cfg
			EOF
		fi
	done

	if use kernel_Darwin; then
		cat >> "${ED}/etc/clang/${triple}-clang++.cfg" <<-EOF || die
			-lc++abi
		EOF
	fi

	newins - "${triple}-clang-cpp.cfg" <<-EOF
		# This configuration file is used by the ${triple}-clang-cpp driver.
		@gentoo-common.cfg
	EOF
	if [[ ${triple} == x86_64* ]]; then
		cat >> "${ED}/etc/clang/${triple}-clang-cpp.cfg" <<-EOF || die
			@gentoo-cet.cfg
		EOF
	fi

	# Install symlinks for triples with other vendor strings since some
	# programs insist on mangling the triple.
	local vendor
	for vendor in gentoo pc unknown; do
		local vendor_triple="${triple%%-*}-${vendor}-${triple#*-*-}"
		for tool in clang{,++,-cpp}; do
			if [[ ! -f "${ED}/etc/clang/${vendor_triple}-${tool}.cfg" ]]; then
				dosym "${triple}-${tool}.cfg" "/etc/clang/${vendor_triple}-${tool}.cfg"
			fi
		done
	done
}

# @FUNCTION: distcc_src_install
# @DESCRIPTION:
# Install distcc symlinks for given llvm in ${SLOT}
distcc_src_install() {
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

	insinto /etc/clang
	doclang_common_cfg ${distcc_target}

	insinto /etc/clang/${SLOT}
	doclang_runtime_cfg ${distcc_target}
}

fi

EXPORT_FUNCTIONS src_install
