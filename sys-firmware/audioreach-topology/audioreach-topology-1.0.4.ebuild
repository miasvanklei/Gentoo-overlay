# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Audioreach Topology"
HOMEPAGE="https://github.com/linux-msm/audioreach-topology"
SRC_URI="https://github.com/linux-msm/audioreach-topology/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

BDEPEND="
	media-sound/alsa-utils
	sys-devel/m4
"
RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-surfacepro12-add-displayport.patch
	"${FILESDIR}"/0002-add-ntmer-tw220.patch

)

src_install() {
	DESTDIR="${D}/lib/firmware" cmake_build install
}
