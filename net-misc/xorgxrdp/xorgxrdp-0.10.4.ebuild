# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An open source Remote Desktop Protocol server; connector for local Xorg session"
HOMEPAGE="http://www.xrdp.org/"
SRC_URI="https://github.com/neutrinolabs/xorgxrdp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=net-misc/xrdp-0.10.4:0=
	x11-base/xorg-server:0=
"
DEPEND=${RDEPEND}
BDEPEND="
	amd64? ( dev-lang/nasm )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/limited-range-bt-601.patch"
	"${FILESDIR}/cleanup-and-fix-shaders.patch"
	"${FILESDIR}/add-panthor-drm-allow-list.patch"
)

src_configure() {
	econf --enable-glamor
}
