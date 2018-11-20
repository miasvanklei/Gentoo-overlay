# Copyright 1999-2018 Gentoo Foundation
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

LICENSE="MIT"
SLOT="0"
IUSE="cuda"

RDEPEND="dev-libs/libltdl
	dev-util/lttng-ust
	!cuda? ( >=sys-devel/clang-6.0 )
	cuda? ( >=sys-devel/clang-6.0[llvm_targets_NVPTX] )
	sys-apps/hwloc[cuda?]
	app-eselect/eselect-opencl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/remove-assert.patch
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CUDA=$(usex cuda)
		-DINSTALL_OPENCL_HEADERS=1
		-DDEFAULT_ENABLE_ICD=0
		-DLLVM_NDEBUG_BUILD=1
		-DPOCL_DEBUG_MESSAGES=OFF
	)

	cmake-utils_src_configure
}
