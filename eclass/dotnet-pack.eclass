# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet-build-base.eclass
# @MAINTAINER:
# mias van klei
# @AUTHOR:
# Mias van Klei (12 Oct 2024)
# @SUPPORTED_EAPIS: 8
# @BLURB: Convenience wrappers for usage by distcc

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DOTNET_PACK_ECLASS} ]]; then
_DOTNET_PACK_ECLASS=1

inherit dotnet-utils

S="${WORKDIR}"

# @FUNCTION: dotnet-pkg_src_unpack
# @DESCRIPTION:
# Default "src_unpack" for the "dotnet-pack" eclass.
# Unpack the package sources.
#
# Includes a case for nugets (".nupkg" files) - they are instead
# unpacked with in in the "WORKDIR" directory
dotnet-pack_src_unpack() {
	dotnet-utils_src_unpack
}

# @FUNCTION: dotnet-pkg_src_install
# @DESCRIPTION:
# Default "src_install" for the "dotnet-pack" eclass.
#
# See "install_dotnet_runtime_pack" or "install_targeting_pack", for installation logic
dotnet-pack_src_install() {
	if [ -n "${RUNTIME_PACK}" ]; then
		dotnet-utils_install_dotnet_runtime_pack "${RUNTIME_PACK}"
	elif [ -n "${TARGETING_PACK}" ]; then
		dotnet-utils_install_targeting_pack "${TARGETING_PACK}"
	else
		default_src_install
	fi
}

fi

EXPORT_FUNCTIONS src_unpack src_install
