# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic multilib-minimal \
	python-single-r1 toolchain-funcs pax-utils

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/cfe-${PV}.src.tar.xz
	http://llvm.org/releases/${PV}/clang-tools-extra-${PV}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug +default-compiler-rt +default-libcxx -doc multitarget python
	+static-analyzer test xml video_cards_radeon kernel_FreeBSD"

RDEPEND="
	~sys-devel/llvm-${PV}:=[debug=,multitarget?,video_cards_radeon?,${MULTILIB_USEDEP}]
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
	default-compiler-rt? ( sys-libs/compiler-rt )
	default-libcxx? ( sys-libs/libcxx )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/cfe-${PV/_}.src

src_unpack() {
	default

	mv "${WORKDIR}"/clang-tools-extra-${PV/_}.src "${S}"/tools/extra \
		|| die "clang-tools-extra source directory move failed"
}

pkg_pretend() {
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

pkg_setup() {
	pkg_pretend

	python-single-r1_pkg_setup
}

src_prepare() {
	python_setup

	# fix race condition between sphinx targets
	eapply "${FILESDIR}"/0001-cmake-Add-ordering-dep-between-HTML-Sphinx-docs-and-.patch
	# automatically select active system GCC's libraries, bugs #406163 and #417913
	# TODO: cross-linux tests broken by this one
	eapply "${FILESDIR}"/0002-driver-Support-obtaining-active-toolchain-from-gcc-c.patch
	# support overriding clang runtime install directory
	eapply "${FILESDIR}"/0005-cmake-Supporting-overriding-runtime-libdir-via-CLANG.patch
	# support overriding LLVMgold.so plugin directory
	eapply "${FILESDIR}"/0006-cmake-Add-CLANG_GOLD_LIBDIR_SUFFIX-to-specify-loc-of.patch
	# fix stand-alone doc build
	eapply "${FILESDIR}"/0007-cmake-Support-stand-alone-Sphinx-doxygen-doc-build.patch

	# be able to specify default values for -rtlib at build time
	eapply "${FILESDIR}"/0008-default-rtlib.patch

	# enable clang to recognize musl-libc
	eapply "${FILESDIR}"/0009-Add-dynamic-linker.patch

	# optimizations like ssp, pie, relro, and removal of crt files.
	eapply "${FILESDIR}"/0010-add-gentoo-linux-distro.patch
	eapply "${FILESDIR}"/0011-Use-z-relro-on-Alpine-Linux.patch
	eapply "${FILESDIR}"/0012-Use-hash-style-gnu-for-Gentoo-Linux.patch
	eapply "${FILESDIR}"/0013-Enable-PIE-by-default-for-gentoo-linux.patch
	eapply "${FILESDIR}"/0014-Link-with-z-now-by-default-for-Gentoo-Linux.patch
	eapply "${FILESDIR}"/0015-fix-crt-files.patch
	eapply "${FILESDIR}"/0016-use-ssp-by-default.patch

	# compile/link compiler-rt shared
	eapply "${FILESDIR}"/0017-link-compiler-rt-shared.patch

	# fixes for removing gcc, like increase gcc version for portage,
	# remove rtm for qt, update cxx standard for qt, or ada check binutils.
	eapply "${FILESDIR}"/0018-fix-ada-in-configure.patch
	eapply "${FILESDIR}"/0019-increase-gcc-version.patch
	eapply "${FILESDIR}"/0020-dont-use-gcc-dir.patch
	eapply "${FILESDIR}"/0021-remove-rtm-haswell.patch
	eapply "${FILESDIR}"/0022-update-default-cxx-standard.patch
	eapply "${FILESDIR}"/0023-add-libunwind-libcxxabi.patch


	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

multilib_src_configure() {
	local targets
	if use multitarget; then
		targets=all
	else
		targets='host;BPF'
		use video_cards_radeon && targets+=';AMDGPU'
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		# install clang runtime straight into /usr/lib
		-DCLANG_LIBDIR_SUFFIX=""
		# specify host's binutils gold plugin path
		-DCLANG_GOLD_LIBDIR_SUFFIX="${NATIVE_LIBDIR#lib}"

		-DLLVM_TARGETS_TO_BUILD="${targets}"
		# TODO: get them properly conditional
		#-DLLVM_BUILD_TESTS=$(usex test)

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

		# enable libomp
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		# llvm options
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_CXX1Y=ON
		-DLLVM_ENABLE_THREADS=ON
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
		)
		use doc && mycmakeargs+=(
			-DCLANG_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/clang"
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

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-clang
}

src_install() {
	# note: magic applied in multilib_src_install()!
	CLANG_VERSION=${PV%.*}

	MULTILIB_CHOST_TOOLS=(
		/usr/bin/clang
		/usr/bin/clang++
		/usr/bin/clang-cl
		/usr/bin/clang-${CLANG_VERSION}
		/usr/bin/clang++-${CLANG_VERSION}
		/usr/bin/clang-cl-${CLANG_VERSION}
	)

	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Remove unnecessary headers on FreeBSD, bug #417171
	if use kernel_FreeBSD && use clang; then
		rm "${ED}"usr/lib/clang/${PV}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	# apply CHOST and CLANG_VERSION to clang executables
	# they're statically linked so we don't have to worry about the lib
	local clang_tools=( clang clang++ clang-cl )
	local i

	# cmake gives us:
	# - clang-X.Y
	# - clang -> clang-X.Y
	# - clang++, clang-cl -> clang
	# we want to have:
	# - clang-X.Y
	# - clang++-X.Y, clang-cl-X.Y -> clang-X.Y
	# - clang, clang++, clang-cl -> clang*-X.Y
	# so we need to fix the two tools
	for i in "${clang_tools[@]:1}"; do
		rm "${ED%/}/usr/bin/${i}" || die
		dosym "clang-${CLANG_VERSION}" "/usr/bin/${i}-${CLANG_VERSION}"
		dosym "${i}-${CLANG_VERSION}" "/usr/bin/${i}"
	done

	# now prepend ${CHOST} and let the multilib-build.eclass symlink it
	if ! multilib_is_native_abi; then
		# non-native? let's replace it with a simple wrapper
		for i in "${clang_tools[@]}"; do
			rm "${ED%/}/usr/bin/${i}-${CLANG_VERSION}" || die
			cat > "${T}"/wrapper.tmp <<-_EOF_
				#!${EPREFIX}/bin/sh
				exec "${i}-${CLANG_VERSION}" $(get_abi_CFLAGS) "\${@}"
			_EOF_
			newbin "${T}"/wrapper.tmp "${i}-${CLANG_VERSION}"
		done
	fi
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

pkg_postinst() {
	if ! has_version 'sys-libs/libomp'; then
		elog "To enable OpenMP support in clang, install sys-libs/libomp."
	fi
}
