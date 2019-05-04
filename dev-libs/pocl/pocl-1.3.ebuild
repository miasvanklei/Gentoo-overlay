# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Portable Computing Language (an implementation of OpenCL)"
HOMEPAGE="http://portablecl.org"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pocl/${PN}"
else
	SRC_URI="https://github.com/pocl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LLVM_TARGET=( NVPTX )
LLVM_TARGET=( "${LLVM_TARGET[@]/#/llvm_targets_}" )

LICENSE="MIT"
SLOT="0"
IUSE="cuda ${LLVM_TARGET[*]} +spirv"
RESTRICT="cuda? ( ${LLVM_TARGET[*]} )"

LLVM_MAX_SLOT=8

RDEPEND="
	dev-libs/ocl-icd
	dev-libs/libltdl
	dev-util/lttng-ust
        sys-devel/llvm:=
        spirv? ( dev-util/spirv-llvm-translator )
	>=sys-devel/clang-6.0[${LLVM_TARGET[*]}?]
	sys-apps/hwloc[cuda?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/remove-assert.patch
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CUDA=$(usex cuda)
		-DINSTALL_OPENCL_HEADERS=0
		-DLLVM_NDEBUG_BUILD=1
		-DPOCL_DEBUG_MESSAGES=OFF
		-DENABLE_SPIRV=$(usex spirv)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	"${ROOT}"/usr/bin/eselect opencl set --use-old ocl-icd
}
