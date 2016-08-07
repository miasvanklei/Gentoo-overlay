# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit qmake-utils flag-o-matic

DESCRIPTION="Telegram API tools for QtQML and Qml"
HOMEPAGE="https://github.com/Aseman-Land/TelegramQML"
if [[ ${PV} == *9999* ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	MY_PV=${PV}-stable
	SRC_URI="https://github.com/Aseman-Land/aseman-qt-tools/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~x86 ~amd64"
	S=${WORKDIR}/${PN}-${MY_PV}
fi

LICENSE="GPLv3"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/qtkeychain
	dev-qt/qtxml:5
	dev-qt/qtimageformats:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's/\/$$LIB_PATH//g' ./asemantools.pro
	eapply_user
}

src_configure() {
	append-cxxflags -Wno-c++11-narrowing
	eqmake5 PREFIX="${EPREFIX}/usr" QT+=widgets QT+=multimedia QT+=dbus QT+=sensors QT+=positioning
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "Failed install"
}
