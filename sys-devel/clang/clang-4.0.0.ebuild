# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic git-r3 multilib-minimal \
	python-single-r1 toolchain-funcs pax-utils

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
EGIT_REPO_URI="http://llvm.org/git/clang.git
        https://github.com/llvm-mirror/clang.git"
EGIT_BRANCH="release_40"

SRC_URI=""

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug +default-compiler-rt +default-libcxx -doc multitarget python
	+static-analyzer xml video_cards_radeon kernel_FreeBSD ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	~sys-devel/llvm-${PV}:=[debug=,${LLVM_TARGET_USEDEPS// /,},${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	!<sys-devel/llvm-${PV}
	${PYTHON_DEPS}"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	xml? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
PDEPEND="
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? ( sys-libs/compiler-rt )
	default-libcxx? ( sys-libs/libcxx )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )
	multitarget? ( ${ALL_LLVM_TARGETS[*]} )"

CMAKE_BUILD_TYPE=Release

check_space() {
	local build_size=650

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space

	python-single-r1_pkg_setup
}

src_unpack() {
	git-r3_fetch "http://llvm.org/git/clang-tools-extra.git
		https://github.com/llvm-mirror/clang-tools-extra.git"
	git-r3_fetch

	git-r3_checkout http://llvm.org/git/clang-tools-extra.git \
		"${S}"/tools/extra
	git-r3_checkout
}

src_prepare() {
	python_setup

	# fix stand-alone doc build
	eapply "${FILESDIR}"/0004-cmake-Support-stand-alone-Sphinx-doxygen-doc-build.patch

	# optimizations like ssp, pie, relro
	eapply "${FILESDIR}"/0006-Use-z-relro_now-and-hashstyle-gnu-on-gentoo-linux.patch
	eapply "${FILESDIR}"/0007-Enable-PIE-by-default-for-gentoo-linux.patch
	eapply "${FILESDIR}"/0008-use-ssp-by-default.patch

	# link libunwind
	eapply "${FILESDIR}"/0009-link-libunwind.patch

	# remove gcc quirks
	eapply "${FILESDIR}"/0010-fix-ada-in-configure.patch
	eapply "${FILESDIR}"/0011-increase-gcc-version.patch
	eapply "${FILESDIR}"/0012-remove-gcc-detection.patch

	# rtm is not availible on all haswell
	eapply "${FILESDIR}"/0013-remove-rtm-haswell.patch

	# patches for c++
	eapply "${FILESDIR}"/0014-update-default-cxx-standard.patch
	eapply "${FILESDIR}"/0015-link-libcxxabi.patch

	# fixes for musl
	eapply "${FILESDIR}"/0016-dont-define-on-musl.patch
	eapply "${FILESDIR}"/0017-define__std_iso_10646__.patch

	# remove dependency on crtbegin* and crtend*
	eapply "${FILESDIR}"/0019-remove-crtfiles.patch
	eapply "${FILESDIR}"/0020-fuse-init-array.patch
	eapply "${FILESDIR}"/0021-dont-use-__dso_handle.patch

	# needed in linux kernel
	eapply "${FILESDIR}"/0022-add-fno-delete-null-pointer-checks.patch

	# add swift support
	eapply "${FILESDIR}"/0023-add-swift-support.patch
	eapply "${FILESDIR}"/0024-fix-import-module.patch

	# User patches
	eapply_user
}

multilib_src_configure() {
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(get_version_component_range 1-3 "${llvm_version}")
	local mycmakeargs=(
                # ensure that the correct llvm-config is used
                -DLLVM_CONFIG="${EPREFIX}/usr/bin/${CHOST}-llvm-config"
                # relative to bindir
                -DCLANG_RESOURCE_DIR="../lib/clang/${clang_version}"

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"

		-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
		# libgomp support fails to find headers without explicit -I
		# furthermore, it provides only syntax checking
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		# override default stdlib and rtlib
		-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
		-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

		# enable static-analyzer when needed
		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)

		# llvm options
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON

		# enable polly
		-DWITH_POLLY=ON
		-DLINK_POLLY_INTO_TOOLS=ON
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
		)
		use doc && mycmakeargs+=(
			-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/clang"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
	else
		mycmakeargs+=(
			-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_BUILD=OFF
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

src_install() {
	MULTILIB_WRAPPED_HEADERS+=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	 # Move runtime headers to /usr/lib/clang, where they belong
	dodir /usr/lib
	mv "${ED}usr/include/clangrt" "${ED}usr/lib/clang" || die

	# Apply CHOST and version suffix to clang tools
	# note: we use two version components here (vs 3 in runtime path)
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(get_version_component_range 1-2 "${llvm_version}")
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local abi i

	# cmake gives us:
	# - clang-X.Y
	# - clang -> clang-X.Y
	# - clang++, clang-cl, clang-cpp -> clang
	# we want to have:
	# - clang-X.Y
	# - clang++-X.Y, clang-cl-X.Y, clang-cpp-X.Y -> clang-X.Y
	# - clang, clang++, clang-cl, clang-cpp -> clang*-X.Y
	# also in CHOST variant
	for i in "${clang_tools[@]:1}"; do
		rm "${ED%/}/usr/bin/${i}" || die
		dosym "clang-${clang_version}" "/usr/bin/${i}-${clang_version}"
		dosym "${i}-${clang_version}" "/usr/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${clang_version}" \
				"/usr/bin/${abi_chost}-${i}-${clang_version}"
			dosym "${abi_chost}-${i}-${clang_version}" \
				"/usr/bin/${abi_chost}-${i}"
		done
	done


	# Remove unnecessary headers on FreeBSD, bug #417171
	if use kernel_FreeBSD; then
		rm "${ED}"usr/lib/clang/${PV}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	# move headers to include/ to get them checked for ABI mismatch
	# (then to the correct directory in src_install())
	insinto /usr/include/clangrt
	doins -r "${ED}usr/$(get_libdir)/clang"/.
	rm -r "${ED}usr/$(get_libdir)/clang" || die
}

multilib_src_install_all() {
	if use python ; then
		pushd bindings/python/clang >/dev/null || die

		python_moduleinto clang
		python_domodule *.py

		popd >/dev/null || die
	fi

	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"usr/share/scan-view
	fi
}
