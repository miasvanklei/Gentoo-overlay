# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet-utils.eclass
# @MAINTAINER:
# Mias van Klei
# @AUTHOR:
# Mias van Klei (12 Oct 2024)
# @SUPPORTED_EAPIS: 8
# @BLURB: Utils for building the dotnet-runtime

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DOTNET_UTILS_ECLASS} ]]; then
_DOTNET_UTILS_ECLASS=1

# dotnet versioning deviates for non-release versions
if [[ -z ${DOTNET_RUNTIME_PV} ]] ; then
	die "${ECLASS}: DOTNET_RUNTIME_PV not set"
fi

SRC_URI=""

# @FUNCTION: add_src_uris_nupkg
# @DESCRIPTION:
# Adds all nuget packages with version conditioned on arch to SRC_URI
#
# Used by "dotnet-utils".
dotnet-utils_add_src_uris_nupkg() {
	local name arch
	local test=""
	for p in "${NUGETS[@]}"; do
		set -- $p
		name=$1 arch=$2
		local uri="https://api.nuget.org/v3-flatcontainer/${name}/${DOTNET_RUNTIME_PV}/${name}.${DOTNET_RUNTIME_PV}.nupkg"

		if [[ -z "$arch" ]]; then
			SRC_URI+=" ${uri}"
		else
			SRC_URI+=" ${arch}? ( ${uri} )"
		fi
	done
}

dotnet-utils_add_src_uris_nupkg

# @FUNCTION: dotnet-utils_get_pkg_rid
# @DESCRIPTION:
# Return the .NET rid used.
#
# Used by "dotnet-utils/dotnet-pack/dotnet-runtime".
dotnet-utils_get_pkg_rid() {
	local fallbackrid="$(dotnet-utils_get_pkg_fallback_rid)"

	local arch
	if use amd64; then
		arch="-x64"
	else
		arch="-${ARCH}"
	fi

	echo "${fallbackrid}${arch}"
}

# @FUNCTION: dotnet-utils_get_pkg_fallback_rid
# @DESCRIPTION:
# Return the .NET rid used.
#
# Used by "dotnet-utils/dotnet-pack/dotnet-runtime".
dotnet-utils_get_pkg_fallback_rid() {
	local withArch="$1"
	local libc="$(usex elibc_musl "-musl" "")"

	echo "linux${libc}"
}

# @FUNCTION: dotnet-utils_src_unpack
# @DESCRIPTION:
# Runs default unpacker, except for nupkg.
# nupkg are unpacked with name of nupkg
#
# Used by "dotnet-pack/dotnet-runtime".
dotnet-utils_src_unpack() {
	local a

	for a in ${A}; do
		case "${a}" in
			*.nupkg)
				local basename=${a%.nupkg*}
				local destdir=${WORKDIR}/${basename}
				mkdir "${destdir}" || die
				unzip -qq -d "${destdir}" "${DISTDIR}/${a}" || die
				;;
			*)
				# Fallback to the default unpacker.
				unpack "${a}"
				;;
		esac
	done
}

# @FUNCTION: dotnet-utils_create_version_files
# @DESCRIPTION:
# DOTNET CMake build system scripts don't have logic for creating the runtime_version.h header file
# The header file itself is however created using dotnet itself. This prevents bootstrapping.
# Instead generate the file manually and copy it to expected location.
#
# Used by "dotnet-runtime".
dotnet-utils_create_version_files() {
	local versionfolder="${DOTNET_ROOT_DIR}/eng/native/version/"
	cat <<- _EOF_ > "${versionfolder}"/runtime_version.h
		#define RuntimeAssemblyMajorVersion $(ver_cut 1)
		#define RuntimeAssemblyMinorVersion $(ver_cut 2)

		#define RuntimeFileMajorVersion 42
		#define RuntimeFileMinorVersion 42
		#define RuntimeFileBuildVersion 42
		#define RuntimeFileRevisionVersion 42424

		#define RuntimeProductMajorVersion $(ver_cut 1)
		#define RuntimeProductMinorVersion $(ver_cut 2)
		#define RuntimeProductPatchVersion $(ver_cut 3)

		#define RuntimeProductVersion ${DOTNET_RUNTIME_PV}
	_EOF_

	cat <<- _EOF_ > "${versionfolder}"/_version.c
		static char sccsid[] __attribute__((used)) = "@(#)Version ${DOTNET_RUNTIME_PV} @Commit: ${DOTNET_COMMIT}";
	_EOF_

	mkdir -p "${DOTNET_ROOT_DIR}"/artifacts/obj || die

	for path in "${versionfolder}/"*{.h,.c}; do
		cp ${path} "${DOTNET_ROOT_DIR}"/artifacts/obj || die
	done
}

# @FUNCTION: dotnet-utils_install_dotnet_runtime_pack
# @DESCRIPTION:
# Install a (ASP).NET runtime pack.
#
# Used by "dotnet-runtime".
dotnet-utils_install_dotnet_runtime_pack() {
	[[ $# -eq 1 ]] || die "${FUNCNAME}: bad number of arguments"

	local packname="$1"
	local pkgrid="$(dotnet-utils_get_pkg_rid)"
	local nugetpkgname="${packname,,}.runtime.${pkgrid}.${DOTNET_RUNTIME_PV}"

	local packdir="packs/${packname}.Runtime.${pkgrid}/${DOTNET_RUNTIME_PV}"
	local basedir="/usr/lib/dotnet-sdk"
	local shareddir="shared/${packname}/${DOTNET_RUNTIME_PV}"
	local libdir="runtimes/${pkgrid}/lib/net$(ver_cut 1-2)"
	local nativedir="runtimes/${pkgrid}/native"

	insinto "${basedir}/${shareddir}"
	for target in "${DOTNET_TARGETS[@]}"; do
		local filename="$(basename $target)"
		doins "${BUILD_DIR}/${target}"
		dosym -r "${basedir}/${shareddir}/${filename}" "${basedir}/${packdir}/${nativedir}/${filename}"
	done
	for i in "${WORKDIR}/${nugetpkgname}/${libdir}"/*{.dll,.json}; do
		local filename="$(basename $i)"
		doins "$i"
		dosym -r "${basedir}/${shareddir}/${filename}" "${basedir}/${packdir}/${libdir}/${filename}"
	done

	insinto "${basedir}/${packdir}"
	doins -r "${WORKDIR}/${nugetpkgname}/data"
}

# @FUNCTION: dotnet-utils_install_dotnet_targeting_pack
# @DESCRIPTION:
# Install a (ASP).NET runtime reference pack.
#
# Used by "dotnet-pack".
dotnet-utils_install_targeting_pack() {
	[[ $# -eq 1 ]] || die "${FUNCNAME}: bad number of arguments"

	local packname="$1"
	local srcdir="${WORKDIR}/${packname,,}.${DOTNET_RUNTIME_PV}"
	local packdir="/usr/lib/dotnet-sdk/packs/${packname}/${DOTNET_RUNTIME_PV}"

	insinto "${packdir}"
	doins -r "${srcdir}/data"
	doins -r "${srcdir}/ref"

	if [ -d "${srcdir}/analyzers" ]; then
		doins -r "${srcdir}/analyzers"
	fi
}

fi
