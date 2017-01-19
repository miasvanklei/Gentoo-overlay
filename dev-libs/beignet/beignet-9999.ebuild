# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_5 )
CMAKE_BUILD_TYPE="Release"

inherit python-any-r1 cmake-multilib toolchain-funcs git-r3

DESCRIPTION="OpenCL implementation for Intel GPUs"
HOMEPAGE="https://01.org/beignet"

LICENSE="LGPL-2.1+"
SLOT="0"

EGIT_REPO_URI="git://anongit.freedesktop.org/beignet"
KEYWORDS=""

COMMON="${PYTHON_DEPS}
	media-libs/mesa
	sys-devel/clang
	>=sys-devel/llvm-3.5
	x11-libs/libdrm[video_cards_intel]
	x11-libs/libXext
	x11-libs/libXfixes"
RDEPEND="${COMMON}
	app-eselect/eselect-opencl"
DEPEND="${COMMON}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/no-debian-multiarch.patch
	"${FILESDIR}"/beignet-1.2.0_no-hardcoded-cflags.patch
	"${FILESDIR}"/musl-fixes.patch
	"${FILESDIR}"/llvm-4.0.patch
)

DOCS=(
	docs/.
)

pkg_setup() {
	python_setup
}

src_prepare() {
	cmake-utils_src_prepare
	# We cannot run tests because they require permissions to access
	# the hardware, and building them is very time-consuming.
	cmake_comment_add_subdirectory utests
}

multilib_src_configure() {
	VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${VENDOR_DIR}"
		-DENABLE_GL_SHARING=TRUE
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	VENDOR_DIR="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	cmake-utils_src_install

	insinto /etc/OpenCL/vendors/
	echo "${VENDOR_DIR}/lib/${PN}/libcl.so" > "${PN}-${ABI}.icd" || die "Failed to generate ICD file"
	doins "${PN}-${ABI}.icd"

	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libOpenCL.so
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so.1
	dosym "lib/${PN}/libcl.so" "${VENDOR_DIR}"/libcl.so
}
