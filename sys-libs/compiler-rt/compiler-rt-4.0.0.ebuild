# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Compiler runtime libraries for clang"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS=""
IUSE=""

RDEPEND="
	!<sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	~sys-devel/llvm-${PV}
	${PYTHON_DEPS}"

test_compiler() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

PATCHES=(
	"${FILESDIR}"/compiler-rt-0001-add-blocks-support.patch
)

CMAKE_BUILD_TYPE=Release

S=${WORKDIR}/${P/_/}.src

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if ! test_compiler; then
		local extra_flags=( -nodefaultlibs -lc )
		if test_compiler "${extra_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${extra_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${extra_flags[*]}"
		fi
	fi

	local clang_version=4.0.0
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${clang_version}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${clang_version}"

		# currently lit covers only sanitizer tests
		-DCOMPILER_RT_INCLUDE_TESTS=OFF
		-DCOMPILER_RT_BUILD_BUILTINS=ON
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_MUSL=$(usex elibc_musl)
		-DCOMPILER_RT_BUILD_XRAY=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# includes are mistakenly installed for all sanitizers and xray
        rm -rf "${ED}"usr/lib/clang/*/include || die

	local clang_version=4.0.0

	mkdir -p "${ED}"etc/env.d
	echo "LDPATH=\"/usr/lib/clang/${clang_version}/lib/linux\"" > "${ED}"etc/env.d/04clang-x86_64-gentoo-linux-musl
}
