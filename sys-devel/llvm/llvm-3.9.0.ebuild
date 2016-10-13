# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.6.1-r1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic \
	multilib-minimal pax-utils python-any-r1 toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	lld? ( http://llvm.org/releases/${PV}/lld-${PV}.src.tar.xz )
	!doc? ( http://dev.gentoo.org/~mgorny/dist/${PN}-3.9.0_rc3-manpages.tar.bz2 )"

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="debug -doc -gold +libedit +libffi +lld multitarget +ncurses ocaml test
	video_cards_radeon kernel_Darwin ${ALL_LLVM_TARGETS[*]}"

# python is needed for llvm-lit (which is installed)
RDEPEND="
	sys-libs/zlib:0=
	gold? ( >=sys-devel/binutils-2.22:*[cxx] )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	ocaml? (
		>=dev-lang/ocaml-4.00.0:0=
		dev-ml/ocaml-ctypes:= )"
DEPEND="${RDEPEND}
	dev-lang/perl
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-5.1 )
	kernel_Darwin? ( <sys-libs/libcxx-${PV%_rc*}.9999 )
	doc? ( dev-python/sphinx )
	gold? ( sys-libs/binutils-libs )
	libffi? ( virtual/pkgconfig )
	ocaml? ( dev-ml/findlib
	 	test? ( dev-ml/ounit ) )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )
	multitarget? ( ${ALL_LLVM_TARGETS[*]} )"

S=${WORKDIR}/${P/_}.src

pkg_pretend() {
	# in megs
	# !debug !multitarget -O2       400
	# !debug  multitarget -O2       550
	#  debug  multitarget -O2      5G

	local build_size=550

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
}


src_unpack() {
	default

        mv "${WORKDIR}"/lld-${PV/_}.src "${S}"/tools/lld \
                || die "lld source directory move failed"
}

src_prepare() {
	# Python is needed to run tests using lit
	python_setup

	# Fix libdir for ocaml bindings install, bug #559134
	eapply "${FILESDIR}"/0001-cmake-Install-OCaml-modules-into-correct-package-loc.patch
	# Do not build/install ocaml docs with USE=-doc, bug #562008
	eapply "${FILESDIR}"/0002-cmake-Make-OCaml-docs-dependent-on-LLVM_BUILD_DOCS.patch

	# Make it possible to override Sphinx HTML install dirs
	# https://llvm.org/bugs/show_bug.cgi?id=23780
	eapply "${FILESDIR}"/0003-cmake-Support-overriding-Sphinx-HTML-doc-install-dir.patch

	# Prevent race conditions with parallel Sphinx runs
	# https://llvm.org/bugs/show_bug.cgi?id=23781
	eapply "${FILESDIR}"/0004-cmake-Add-an-ordering-dep-between-HTML-man-Sphinx-ta.patch

	# Prevent installing libgtest
	# https://llvm.org/bugs/show_bug.cgi?id=18341
	eapply "${FILESDIR}"/0005-cmake-Do-not-install-libgtest.patch

	# Allow custom cmake build types (like 'Gentoo')
	eapply "${FILESDIR}"/0006-cmake-Remove-the-CMAKE_BUILD_TYPE-assertion.patch

	# Fix llvm-config for shared linking and sane flags
	# https://bugs.gentoo.org/show_bug.cgi?id=565358
	eapply "${FILESDIR}"/0007-llvm-config-Clean-up-exported-values-update-for-shar.patch

	# Restore SOVERSIONs for shared libraries
	# https://bugs.gentoo.org/show_bug.cgi?id=578392
	eapply "${FILESDIR}"/0008-cmake-Restore-SOVERSIONs-on-shared-libraries.patch

	# support building llvm against musl-libc
	use elibc_musl && eapply "${FILESDIR}"/musl-fixes.patch

	# output correct host
	use elibc_musl && eapply "${FILESDIR}"/0009-output-my-chost.patch

	# llvm-readobj has allmost all options
	eapply "${FILESDIR}"/0010-llvm-readobj-binutils-compat.patch

	# add llvm-strings and llvm-cxxfilt
	eapply "${FILESDIR}"/0011-llvm-add-cxxfilt.patch
	eapply "${FILESDIR}"/0012-llvm-add-strings.patch


	if use lld; then
		eapply "${FILESDIR}"/0014-lld-gnu-ld-compat.patch
		eapply "${FILESDIR}"/0015-lld-ignore-options.patch
		eapply "${FILESDIR}"/0016-lld-add-nostdlib.patch

		# bugs found by compiling ghc
		eapply "${FILESDIR}"/0017-lld-do-not-merge-sections-in-case-of-relocatable-object-generation.patch
		eapply "${FILESDIR}"/0018-lld-do-not-ignore-relocations-addends.patch

		# bugs found by compiling rust
		eapply "${FILESDIR}"/0019-lld-accept-sh_entsize0.patch
		eapply "${FILESDIR}"/0020-lld-fix-dt_needed-value.patch
	fi

	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# User patches
	eapply_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

multilib_src_configure() {
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$(pkg-config --cflags-only-I libffi)
		ffi_ldflags=$(pkg-config --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_CXX1Y=ON
		-DLLVM_ENABLE_THREADS=ON
		-DWITH_POLLY=OFF # TODO
		-DLLVM_ENABLE_LLD=ON

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DHAVE_HISTEDIT_H=$(usex libedit)
	)

	if ! multilib_is_native_abi || ! use ocaml; then
		mycmakeargs+=(
			-DOCAMLFIND=NO
		)
	fi
#	Note: go bindings have no CMake rules at the moment
#	but let's kill the check in case they are introduced
#	if ! multilib_is_native_abi || ! use go; then
		mycmakeargs+=(
			-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND
		)
#	fi

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_UTILS=ON
		)

		use doc && mycmakeargs+=(
			-DLLVM_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
		use gold && mycmakeargs+=(
			-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/llvm-tblgen" ]] \
			|| die "/usr/bin/llvm-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN=/usr/bin/llvm-tblgen
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	# TODO: not sure why this target is not correctly called
	multilib_is_native_abi && use doc && use ocaml && cmake-utils_src_make docs/ocaml_doc

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/config.h
		/usr/include/llvm/Config/llvm-config.h
	)

	multilib-minimal_src_install
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi; then
		# Symlink the gold plugin.
		if use gold; then
			dodir "/usr/${CHOST}/binutils-bin/lib/bfd-plugins"
			dosym "../../../../$(get_libdir)/LLVMgold.so" \
				"/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so"
		fi
	fi
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/.
	# some users may find it useful
	dodoc utils/vim/vimrc

	if ! use doc; then
		doman "${WORKDIR}"/${PN}-3.9.0_rc3-manpages/*.1
	fi
}
