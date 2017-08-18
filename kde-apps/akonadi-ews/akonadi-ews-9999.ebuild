# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_MIRROR="https://github.com/KrissN"
KDE_BUILD_TYPE=live
inherit kde5

DESCRIPTION="Akonadi resource agent for Microsoft Exchange using Exchange Web Services (EWS) protocol"
HOMEPAGE="https://github.com/KrissN/akonadi-ews"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	kde-frameworks/kcmutils
	kde-frameworks/kcodecs
	kde-frameworks/kconfig
	kde-frameworks/kconfigwidgets
	kde-frameworks/kcoreaddons
	kde-frameworks/kdelibs4support
	kde-frameworks/kio
	kde-frameworks/krunner
	kde-apps/akonadi
	kde-apps/akonadi-mime
	kde-apps/kcalcore
	kde-apps/kcontacts
	kde-apps/kmime
	dev-qt/qtcore
"
DEPEND="${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"
