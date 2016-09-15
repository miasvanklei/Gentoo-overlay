# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://www.kde.org/applications/development"
KEYWORDS="~amd64 ~x86"
IUSE="cvs nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep dolphin-plugins)
	$(add_kdeapps_dep kapptemplate)
	$(add_kdeapps_dep kde-dev-scripts)
	$(add_kdeapps_dep kompare)
	$(add_kdeapps_dep libkomparediff2)
	$(add_kdeapps_dep lokalize)
	$(add_kdeapps_dep okteta)
	$(add_kdeapps_dep poxml)
	$(add_kdeapps_dep umbrello)
	cvs? ( $(add_kdeapps_dep cervisia) )
	nls? (
		$(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL})
		$(add_kdeapps_dep kde4-l10n '' ${L10N_MINIMAL})
	)
"
