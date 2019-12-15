# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils


DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"
SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${PV}.tar.gz"
S="${WORKDIR}/media-driver-intel-media-${PV}"
KEYWORDS="~amd64"

LICENSE="MIT BSD"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/gmmlib-19.3.0
	>=x11-libs/libva-2.5.0
	>=x11-libs/libpciaccess-0.13.1-r1:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix-cflags.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DMEDIA_BUILD_FATAL_WARNINGS=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

        # Setup environment
	cat <<-EOF > "${T}"/03${PN}
	LIBVA_DRIVER_NAME=iHD
	EOF
	doenvd "${T}"/03${PN}
}
