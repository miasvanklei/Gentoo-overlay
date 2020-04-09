# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build readme.gentoo-r1

DESCRIPTION="Virtual for OpenCL API"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/opencl-icd-loader"

# so that src_install() doesn't fail on missing directory
S="${WORKDIR}"

src_install() {
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
