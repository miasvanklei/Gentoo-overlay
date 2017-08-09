# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic git-r3 multilib-minimal pax-utils \
	python-any-r1 toolchain-funcs versionator

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/llvm.git
        https://github.com/llvm-mirror/llvm.git"
EGIT_BRANCH="release_50"

# Keep in sync with CMakeLists.txt
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. ARM backend: LLVM Software Grant by ARM.
# 3. MD5 code: public-domain.
# 4. Tests (not installed):
#  a. gtest: BSD.
#  b. YAML tests: MIT.

LICENSE="UoI-NCSA rc BSD public-domain
	llvm_targets_ARM? ( LLVM-Grant )"
SLOT="$(get_major_version)"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug +doc gold libedit +libffi ncurses +swift test
	kernel_Darwin ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	sys-libs/zlib:0=
	gold? ( >=sys-devel/binutils-2.22:*[cxx] )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	dev-lang/perl
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/lld-${PV}:= >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-5.1 )
	kernel_Darwin? ( <sys-libs/libcxx-$(get_version_component_range 1-3).9999 )
	doc? ( dev-python/sphinx )
	gold? ( sys-libs/binutils-libs )
	libffi? ( virtual/pkgconfig )
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND="${RDEPEND}
	!sys-devel/llvm:0"
PDEPEND="sys-devel/llvm-common
	gold? ( sys-devel/llvmgold )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )"

S=${WORKDIR}/${P/_/}

# least intrusive of all
CMAKE_BUILD_TYPE=Release

python_check_deps() {
	! use test \
		|| has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

src_unpack() {
        git-r3_fetch "https://git.llvm.org/git/polly.git
                https://github.com/llvm-mirror/polly.git"
        git-r3_fetch

        git-r3_checkout https://llvm.org/git/polly.git "${S}"/tools/polly
        git-r3_checkout
}

src_prepare() {
	# use init-array as default
	eapply "${FILESDIR}"/0001-use-init-array.patch

	# change library suffix for shared libraries
	eapply "${FILESDIR}"/0002-shared-library-suffix.patch

	# support building llvm against musl-libc
	use elibc_musl && eapply "${FILESDIR}"/0003-musl-fixes.patch

	# some arm relocations, needed for swift
	eapply "${FILESDIR}"/0004-arm-relocation.patch

	# add swift support
	use swift && eapply "${FILESDIR}"/0005-add-swift-support.patch

	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# User patches
	eapply_user
}

multilib_src_configure() {
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_APPEND_VC_REV=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_DYLIB_COMPONENTS="all"
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_LIBEDIT=$(usex libedit)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_THREADS=ON
		-DLLVM_ENABLE_LLD=ON
		-DLLVM_ENABLE_CXX1Y=ON

		# enable polly
		-DLINK_POLLY_INTO_TOOLS=ON
		-DWITH_POLLY=ON

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"

		# disable OCaml bindings (now in dev-ml/llvm-ocaml)
		-DOCAMLFIND=NO
	)

#	Note: go bindings have no CMake rules at the moment
#	but let's kill the check in case they are introduced
#	if ! multilib_is_native_abi || ! use go; then
		mycmakeargs+=(
			-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND
		)
#	fi

	use test && mycmakeargs+=(
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_OCAMLDOC=OFF
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_UTILS=ON
		)
		use doc && mycmakeargs+=(
			-DLLVM_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
		use gold && mycmakeargs+=(
			-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
		)
	fi

	if tc-is-cross-compiler; then
		local tblgen="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/llvm-tblgen"
		[[ -x "${tblgen}" ]] \
			|| die "${tblgen} not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN="${tblgen}"
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

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
		/usr/lib/llvm/${SLOT}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
		/usr/include/llvm/Config/config.h
	)

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	# binutils symlinks
	local llvm_tools=( ar ranlib nm strings objdump cxxfilt readelf )

	for i in "${llvm_tools[@]}"; do
                dosym "llvm-${i}" "/usr/lib/llvm/${SLOT}/bin/${i}"
                dosym "llvm-${i}" "/usr/lib/llvm/${SLOT}/bin/${CHOST}-${i}"
        done

	# move wrapped headers back
	mv "${ED%/}"/usr/include "${ED%/}"/usr/lib/llvm/${SLOT}/include || die
}

multilib_src_install() {
	cmake-utils_src_install

	# move headers to /usr/include for wrapping
	rm -rf "${ED%/}"/usr/include || die
	mv "${ED%/}"/usr/lib/llvm/${SLOT}/include "${ED%/}"/usr/include || die

	LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)" )
}

multilib_src_install_all() {
	local revord=$(( 9999 - ${SLOT} ))
	cat <<-_EOF_ > "${T}/10llvm-${revord}" || die
		PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/usr/lib/llvm/${SLOT}/bin"
		MANPATH="${EPREFIX}/usr/lib/llvm/${SLOT}/share/man"
		LDPATH="$( IFS=:; echo "${LLVM_LDPATHS[*]}" )"
_EOF_
	doenvd "${T}/10llvm-${revord}"
}
