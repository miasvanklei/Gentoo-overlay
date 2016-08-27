# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils flag-o-matic

DESCRIPTION="A different telegram client from Aseman team forked from Sigram by Sialan Labs. "
HOMEPAGE="http://aseman.co/en/products/cutegram/"
if [[ ${PV} == *9999* ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/Cutegram"
	KEYWORDS=""
else
	MY_PV=${PV}-dev
	HASH_TOOLS="91bf14b790c749bcaaddb09a8124ef6415a93906"
	SRC_URI="
		https://github.com/Aseman-Land/Cutegram/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	RESTRICT="mirror"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/Cutegram-${MY_PV}"
fi

LICENSE="GPLv3"
SLOT="0"
IUSE=""

DEPEND="
	>=net-misc/TelegramQML-0.9.1
	net-misc/aseman-qt-tools
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtdeclarative:5[localstorage]
"
RDEPEND="${DEPEND}"

src_configure(){
	local myeqmakeargs=(
		cutegram.pro
		PREFIX="${EPREFIX}/usr"
		DESKTOPDIR="${EPREFIX}/usr/share/applications"
		ICONDIR="${EPREFIX}/usr/share/pixmaps"
	)
	eqmake5 ${myeqmakeargs[@]}
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die "Failed installation"
}
