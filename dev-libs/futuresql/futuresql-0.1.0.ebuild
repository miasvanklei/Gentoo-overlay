# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.101.0
QTMIN=5.15.5
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} == release ]]; then
        SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
        KEYWORDS="amd64 x86"
fi


DESCRIPTION="Simple music player by KDE"
#HOMEPAGE="https://elisa.kde.org/ https://apps.kde.org/elisa/"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="mpris semantic-desktop +vlc"

RESTRICT="test mirror"

BDEPEND=""
DEPEND="
	>=dev-qt/qtsql-${QTMIN}:5
"
RDEPEND="${DEPEND}
"

src_configure() {
	ecm_src_configure
}
