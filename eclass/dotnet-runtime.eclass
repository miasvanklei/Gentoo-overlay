# Copyright 1999-2024 Gentoo Authors
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

inherit cmake dotnet-utils

if [[ -z ${_DOTNET_RUNTIME_ECLASS} ]]; then
_DOTNET_RUNTIME_ECLASS=1

# The 'src_dir' pointing to the source dir for coresetup/coreclr/corefx
if [[ -z ${DOTNET_SRC_DIR} ]] ; then
	die "${ECLASS}: DOTNET_SRC_DIR not set"
fi

DOTNET_ROOT_DIR="${WORKDIR}/runtime-${DOTNET_RUNTIME_PV}"
S="${DOTNET_ROOT_DIR}/${DOTNET_SRC_DIR}"
SRC_URI+=" https://github.com/dotnet/runtime/archive/refs/tags/v${DOTNET_RUNTIME_PV}.tar.gz -> dotnet-runtime-${PV}.tar.gz"

CMAKE_BUILD_TYPE=RELEASE

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

EXPORT_FUNCTIONS src_prepare src_compile src_install
