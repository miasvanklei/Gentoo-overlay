# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="The OpenCL ICD Loader project."
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"
SRC_URI=""
EGIT_REPO_URI="https://github.com/KhronosGroup/OpenCL-ICD-Loader.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+khronos-headers"

DEPEND=""
RDEPEND="app-eselect/eselect-opencl"

DOCS=(README.md)


src_install() {
	cmake-utils_src_install
	OCL_DIR="/usr/$(get_libdir)/OpenCL/vendors/ocl-icd"
        dodir ${OCL_DIR}
        dodir "/usr/lib/pkgconfig"

	cp ${FILESDIR}/OpenCL.pc "${ED}/usr/lib/pkgconfig"
	mv ${ED}/usr/lib/libOpenCL.so* "${ED}${OCL_DIR}" || die "Can't install vendor library"
}

pkg_postinst() {
        eselect opencl set --use-old ${PN}
}
