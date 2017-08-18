# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_MIRROR="https://github.com/KrissN"
inherit kde5

DESCRIPTION="Akonadi resource agent for Microsoft Exchange using Exchange Web Services (EWS) protocol"
HOMEPAGE="https://github.com/KrissN/akonadi-ews"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep krunner)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtcore)
"
DEPEND="${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"
