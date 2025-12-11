# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Audioreach Topology"
HOMEPAGE="https://github.com/linux-msm/audioreach-topology"
EGIT_REPO_URI="https://github.com/linux-msm/audioreach-topology.git"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

BDEPEND="
	media-sound/alsa-utils
	sys-devel/m4
"
RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/add-ntmer-tw220.patch
	"${FILESDIR}"/add-surface-pro-12inch.patch
)

src_install() {
	DESTDIR="${D}/lib/firmware" cmake_build install
}
