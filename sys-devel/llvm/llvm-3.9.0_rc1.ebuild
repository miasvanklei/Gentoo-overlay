# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils eutils flag-o-matic multilib \
	multilib-minimal python-single-r1 toolchain-funcs pax-utils prefix

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/${P/_}.src.tar.xz
        clang? ( http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/compiler-rt-${PV/_}.src.tar.xz
                http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/cfe-${PV/_}.src.tar.xz
                http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/clang-tools-extra-${PV/_}.src.tar.xz )
        lldb? ( http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/lldb-${PV/_}.src.tar.xz )
	lld? ( http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/lld-${PV/_}.src.tar.xz )
	polly? ( http://llvm.org/pre-releases/${PV%_rc*}/${PV/${PV%_rc*}_}/polly-${PV/_}.src.tar.xz )
        !doc? ( http://dev.gentoo.org/~voyageur/distfiles/${PN}-3.8.0-manpages.tar.bz2 )"
LICENSE="UoI-NCSA"
SLOT="0/3.8.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+clang +cxx1y +default-compiler-rt +default-libcxx debug doc +eh +gold -jitevents +libedit +libffi +lldb lld multitarget +ncurses -ocaml +openmp -oprofile +polly
	python +rtti -sanitize +static-analyzer test +threads +xml werror video_cards_radeon kernel_Darwin"

COMMON_DEPEND="
	sys-libs/zlib:0=
	clang? (
		python? ( ${PYTHON_DEPS} )
		static-analyzer? (
			dev-lang/perl:*
			${PYTHON_DEPS}
		)
		xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	)
	gold? ( >=sys-devel/binutils-2.22:*[cxx] )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	lldb? ( dev-python/six[${PYTHON_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	ocaml? (
		>=dev-lang/ocaml-4.00.0:0=
		dev-ml/findlib
		dev-ml/ocaml-ctypes
		!!<=sys-devel/llvm-3.7.0-r1[ocaml] )"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	>=sys-devel/make-3.81
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-5.1 )
	kernel_Darwin? ( sys-libs/libcxx )
	clang? ( xml? ( virtual/pkgconfig ) )
	doc? ( dev-python/sphinx )
	libffi? ( virtual/pkgconfig )
	lldb? ( dev-lang/swig )
	!!<dev-python/configparser-3.3.0.2
	ocaml? ( test? ( dev-ml/ounit ) )
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	default-libcxx? ( sys-libs/libcxx[${MULTILIB_USEDEP}] )
	clang? ( !<=sys-devel/clang-${PV}-r99 )
	openmp? ( sys-libs/libomp )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"
PDEPEND="clang? ( =sys-devel/clang-${PV}-r100 )"

# pypy gives me around 1700 unresolved tests due to open file limit
# being exceeded. probably GC does not close them fast enough.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	lldb? ( clang xml )"

S=${WORKDIR}/${P/_}.src

pkg_pretend() {
	# in megs
	# !clang !debug !multitarget -O2       400
	# !clang !debug  multitarget -O2       550
	#  clang !debug !multitarget -O2       950
	#  clang !debug  multitarget -O2      1200
	# !clang  debug  multitarget -O2      5G
	#  clang !debug  multitarget -O0 -g  12G
	#  clang  debug  multitarget -O2     16G
	#  clang  debug  multitarget -O0 -g  14G

	local build_size=550
	use clang && build_size=1200

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

        if use clang; then
                mv "${WORKDIR}"/cfe-${PV/_}.src "${S}"/tools/clang \
                        || die "clang source directory move failed"
                mv "${WORKDIR}"/compiler-rt-${PV/_}.src "${S}"/projects/compiler-rt \
                        || die "compiler-rt source directory move failed"
                mv "${WORKDIR}"/clang-tools-extra-${PV/_}.src "${S}"/tools/clang/tools/extra \
                        || die "clang-tools-extra source directory move failed"
        fi

        if use lldb; then
                mv "${WORKDIR}"/lldb-${PV/_}.src "${S}"/tools/lldb \
                        || die "lldb source directory move failed"
        fi

        if use lld; then
                mv "${WORKDIR}"/lld-${PV/_}.src "${S}"/tools/lld \
                        || die "lld source directory move failed"
        fi

        if use polly; then
                mv "${WORKDIR}"/polly-${PV/_}.src "${S}"/tools/polly \
                        || die "polly source directory move failed"
        fi
}

src_prepare() {
	# Make ocaml warnings non-fatal, bug #537308
        sed -e "/RUN/s/-warn-error A//" -i test/Bindings/OCaml/*ml  || die
	# Fix libdir for ocaml bindings install, bug #559134
	eapply "${FILESDIR}"/cmake/${PN}-3.7.0-ocaml-multilib.patch
	# Do not build/install ocaml docs with USE=-doc, bug #562008
	eapply "${FILESDIR}"/cmake/${PN}-3.7.0-ocaml-build_doc.patch

	# Make it possible to override Sphinx HTML install dirs
	# https://llvm.org/bugs/show_bug.cgi?id=23780
	eapply "${FILESDIR}"/cmake/0002-cmake-Support-overriding-Sphinx-HTML-doc-install-dir.patch

	# Prevent race conditions with parallel Sphinx runs
	# https://llvm.org/bugs/show_bug.cgi?id=23781
	eapply "${FILESDIR}"/cmake/0003-cmake-Add-an-ordering-dep-between-HTML-man-Sphinx-ta.patch

	# Prevent installing libgtest
	# https://llvm.org/bugs/show_bug.cgi?id=18341
	eapply "${FILESDIR}"/cmake/0004-cmake-Do-not-install-libgtest.patch

	# Allow custom cmake build types (like 'Gentoo')
	eapply "${FILESDIR}"/cmake/${PN}-3.8-allow_custom_cmake_build_types.patch

	# Fix llvm-config for shared linking and sane flags
	# https://bugs.gentoo.org/show_bug.cgi?id=565358
	eapply "${FILESDIR}"/llvm-3.9-llvm-config.patch

        # Restore SOVERSIONs for shared libraries
        # https://bugs.gentoo.org/show_bug.cgi?id=578392
        eapply "${FILESDIR}"/llvm-3.9-soversion.patch

	# fix for llvm musl
	eapply "${FILESDIR}"/llvm-3.8-musl-fixes.patch

        # disable use of SDK on OSX, bug #568758
        sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	if use clang; then
                # Automatically select active system GCC's libraries, bugs #406163 and #417913
                eapply "${FILESDIR}"/clang-3.5-gentoo-runtime-gcc-detection-v3.patch


		# be able to specify default values for -rtlib at build time
		eapply "${FILESDIR}"/clang-3.9-default-rtlib.patch

		# enable clang to recognize musl-libc
		eapply "${FILESDIR}"/musl/cfe/cfe-004-Add-dynamic-linker-3.9.patch

		# Install clang runtime into /usr/lib/clang
		# https://llvm.org/bugs/show_bug.cgi?id=23792
		eapply "${FILESDIR}"/cmake/clang-0001-Install-clang-runtime-into-usr-lib-without-suffix-3.8.patch
		eapply "${FILESDIR}"/cmake/compiler-rt-3.9-cmake-Install-compiler-rt-into-usr-lib-without-suffi.patch

		# Make it possible to override CLANG_LIBDIR_SUFFIX
		# (that is used only to find LLVMgold.so)
		# https://llvm.org/bugs/show_bug.cgi?id=23793
		eapply "${FILESDIR}"/cmake/clang-0002-cmake-Make-CLANG_LIBDIR_SUFFIX-overridable.patch

		# Fix WX sections, bug #421527
		find projects/compiler-rt/lib/builtins -type f -name '*.S' -exec sed \
			 -e '$a\\n#if defined(__linux__) && defined(__ELF__)\n.section .note.GNU-stack,"",%progbits\n#endif' \
			 -i {} + || die

		# Fix for MUSL
		eapply "${FILESDIR}"/musl/cfe/cfe-001-add-gentoo-linux-distro.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-002-Use-z-relro-on-Alpine-Linux.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-003-Use-hash-style-gnu-for-Gentoo-Linux.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-005-Enable-PIE-by-default-for-gentoo-linux.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-006-Link-with-z-now-by-default-for-Gentoo-Linux.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-007-musl-use-init-array.patch
		eapply "${FILESDIR}"/musl/cfe/cfe-008-use-ssp-by-default.patch

		# Other patches
		eapply "${FILESDIR}"/compiler-rt-001-add-blocks-support.patch
		eapply "${FILESDIR}"/cfe-009-fix-ada-in-configure.patch
		eapply "${FILESDIR}"/cfe-010-increase-gcc-version.patch
		eapply "${FILESDIR}"/cfe-012-dont-use-gcc-dir.patch
		eapply "${FILESDIR}"/cfe-013-remove-rtm-haswell.patch
		eapply "${FILESDIR}"/cfe-014-remove-link-crtfiles.patch
		eapply "${FILESDIR}"/update-default-cxx-standard.patch
	fi

	if use lldb; then
		# Do not install dummy readline.so module from
		# https://llvm.org/bugs/show_bug.cgi?id=18841
		sed -e 's/add_subdirectory(readline)/#&/' \
			-i tools/lldb/scripts/Python/modules/CMakeLists.txt || die
		eapply "${FILESDIR}"/lldb-fix-getopt.patch
	fi

	# User patches
	eapply_user

	python_setup

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

	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$(pkg-config --cflags-only-I libffi)
		ffi_ldflags=$(pkg-config --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_ENABLE_TIMESTAMPS=OFF
		-DLLVM_TARGETS_TO_BUILD="${targets}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_CXX1Y=$(usex cxx1y)
		-DLLVM_ENABLE_THREADS=$(usex threads)
		-DLLVM_USE_OPROFILE=$(usex oprofile)
		-DLLVM_USE_INTEL_JITEVENTS=$(usex jitevents)
		-DLLVM_ENABLE_WERROR=$(usex werror)
		-DLLVM_ENABLE_RTTI=$(usex rtti)
		-DLLVM_ENABLE_EH=$(usex eh)
		-DWITH_POLLY=$(usex polly)

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"

		-DHAVE_HISTEDIT_H=$(usex libedit)
	)

	if use clang; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
			# libgomp support fails to find headers without explicit -I
			# furthermore, it provides only syntax checking
			-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

			# override default stdlib and rtlib
			-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
			-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

			# compiler-rt's test cases depend on sanitizer
			-DCOMPILER_RT_BUILD_SANITIZERS=$(usex sanitize)
			-DCOMPILER_RT_INCLUDE_TESTS=$(usex sanitize)
		)
	fi

	if use lldb; then
		mycmakeargs+=(
			-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
			-DLLDB_DISABLE_CURSES=$(usex !ncurses)
			-DLLDB_ENABLE_TERMINFO=$(usex ncurses)
		)
	fi

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
			-DLLVM_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DLLVM_INSTALL_UTILS=ON
		)

		if use clang; then
			mycmakeargs+=(
				-DCLANG_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/clang"
			)
		fi

		if use gold; then
			mycmakeargs+=(
				-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
			)
		fi

		if use lldb; then
			mycmakeargs+=(
				-DLLDB_DISABLE_PYTHON=$(usex !python)
			)
		fi

	else
		if use clang; then
			mycmakeargs+=(
				# disable compiler-rt on non-native ABI because:
				# 1. it fails to configure because of -m32
				# 2. it is shared between ABIs so no point building
				# it multiple times
				-DLLVM_EXTERNAL_COMPILER_RT_BUILD=OFF
				-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_BUILD=OFF
			)
		fi
		if use lldb; then
			mycmakeargs+=(
				# only run swig on native abi
				-DLLDB_DISABLE_PYTHON=ON
			)
		fi
	fi

	if use clang; then
		mycmakeargs+=(
			-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
			-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
			-DCLANG_LIBDIR_SUFFIX="${NATIVE_LIBDIR#lib}"
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
	local test_targets=( check )
	# clang tests won't work on non-native ABI because we skip compiler-rt
	multilib_is_native_abi && use clang && test_targets+=( check-clang )
	cmake-utils_src_make "${test_targets[@]}"
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/config.h
		/usr/include/llvm/Config/llvm-config.h
	)

	if use clang; then
		# note: magic applied in multilib_src_install()!
		CLANG_VERSION=${PV%.*}

		MULTILIB_CHOST_TOOLS+=(
			/usr/bin/clang
			/usr/bin/clang++
			/usr/bin/clang-cl
			/usr/bin/clang-${CLANG_VERSION}
			/usr/bin/clang++-${CLANG_VERSION}
			/usr/bin/clang-cl-${CLANG_VERSION}
		)

		MULTILIB_WRAPPED_HEADERS+=(
			/usr/include/clang/Config/config.h
		)
	fi

	multilib-minimal_src_install
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi; then
		# Install the Manpages
		use doc || doman "${WORKDIR}"/llvm-3.8.0-manpages/*.1

		# Symlink the gold plugin.
		if use gold; then
			dodir "/usr/${CHOST}/binutils-bin/lib/bfd-plugins"
			dosym "../../../../$(get_libdir)/LLVMgold.so" \
				"/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so"
		fi
	fi

	# apply CHOST and CLANG_VERSION to clang executables
	# they're statically linked so we don't have to worry about the lib
	if use clang; then
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
	fi
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/.
	# some users may find it useful
	dodoc utils/vim/vimrc

	if use clang; then
		pushd tools/clang >/dev/null || die

		if use python ; then
			pushd bindings/python/clang >/dev/null || die

			python_moduleinto clang
			python_domodule *.py

			popd >/dev/null || die
		fi

		# AddressSanitizer symbolizer (currently separate)
		dobin "${S}"/projects/compiler-rt/lib/asan/scripts/asan_symbolize.py

		popd >/dev/null || die

		python_fix_shebang "${ED}"
		if use static-analyzer; then
			python_optimize "${ED}"usr/share/scan-view
		fi
	fi
}

pkg_postinst() {
	if use clang && ! has_version 'sys-libs/libomp'; then
		elog "To enable OpenMP support in clang, install sys-libs/libomp."
	fi
}
