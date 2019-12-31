# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Utility to change the OpenCL implementation being used"
HOMEPAGE="https://www.gentoo.org/"

H_COMMIT="745c724b4ac623b1c42044454cb867e537d3917e"

SRC_URI="
	https://dev.gentoo.org/~xarthisius/distfiles/${P}-r1.tar.xz
	https://github.com/KhronosGroup/OpenCL-Headers/archive/${H_COMMIT}.zip
	"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND=">=app-admin/eselect-1.2.4"

pkg_postinst() {
	local impl="$(eselect opencl show)"
	if [[ -n "${impl}"  && "${impl}" != '(none)' ]] ; then
		eselect opencl set "${impl}"
	fi
}

src_install() {
	insinto /usr/share/eselect/modules
	doins opencl.eselect

	insinto /usr/include
	doins -r "${WORKDIR}/OpenCL-Headers-${H_COMMIT}/CL"
	cp "${FILESDIR}"/cl.hpp "${ED}/usr/include/CL" || die
	cp "${FILESDIR}"/cl2.hpp "${ED}/usr/include/CL" || die
}
