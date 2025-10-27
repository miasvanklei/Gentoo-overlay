# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet-runtime.eclass
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

if [[ -z ${_DOTNET_RUNTIME_ECLASS} ]]; then
_DOTNET_RUNTIME_ECLASS=1

# The 'src_dir' pointing to the source dir for coresetup/coreclr/corefx
if [[ -z ${DOTNET_SRC_DIR} ]] ; then
	die "${ECLASS}: DOTNET_SRC_DIR not set"
fi

DOTNET_PV="$(ver_cut 1-3)"
DOTNET_PV_SUFFIX="$(ver_cut 4-)"
if [[ -n $DOTNET_PV_SUFFIX ]]; then
        DOTNET_RUNTIME_PV="${DOTNET_PV}-rc.${DOTNET_PV_SUFFIX:2:1}.${DOTNET_PV_SUFFIX:3:5}.${DOTNET_PV_SUFFIX:8:3}"
else
        DOTNET_RUNTIME_PV="${DOTNET_PV}"
fi

inherit cmake dotnet-utils

DOTNET_ROOT_DIR="${WORKDIR}/runtime-${DOTNET_RUNTIME_PV}"
CMAKE_USE_DIR="${DOTNET_ROOT_DIR}/${DOTNET_SRC_DIR}"
S="${DOTNET_ROOT_DIR}"
SRC_URI+=" https://github.com/dotnet/runtime/archive/refs/tags/v${DOTNET_RUNTIME_PV}.tar.gz -> dotnet-runtime-${DOTNET_RUNTIME_PV}.tar.gz"

# @FUNCTION: dotnet-pkg_src_unpack
# @DESCRIPTION:
# Default "src_unpack" for the "dotnet-runtime" eclass.
# Unpack the package sources.
#
# Includes a case for nugets (".nupkg" files) - they are instead
# unpacked with in in the "WORKDIR" directory
dotnet-runtime_src_unpack() {
        dotnet-utils_src_unpack
}

# @FUNCTION: dotnet-runtime_src_prepare
# @DESCRIPTION:
# Default "src_prepare" for the "dotnet-runtime" eclass.
#
# Runs "cmake_src_prepare" and creates the necessary 'version' files
dotnet-runtime_src_prepare() {
	dotnet-utils_create_version_files
	cmake_src_prepare
}

# @FUNCTION: dotnet-runtime_src_compile
# @DESCRIPTION:
# Default "src_compile" for the "dotnet-runtime" eclass.
#
# Runs "cmake_src_compile" for the defined targets in "DOTNET_TARGETS"
dotnet-runtime_src_compile() {
	cmake_src_compile "${DOTNET_TARGETS[@]}"
}

# @FUNCTION: dotnet-runtime_src_install
# @DESCRIPTION:
# Default "src_install" for the "dotnet-runtime" eclass.
#
# Runs "cmake_src_install" (default) or installs a runtime pack
dotnet-runtime_src_install() {
	if [ -n "${RUNTIME_PACK}" ]; then
		dotnet-utils_install_dotnet_runtime_pack "${RUNTIME_PACK}"
	else
		cmake_src_install
	fi
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install
