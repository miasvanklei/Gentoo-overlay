# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Meta package for the KDE Applications collection"
KEYWORDS=" ~amd64 ~x86"
IUSE="pim sdk"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep kate)
	=kde-apps/kfind-9999
	=kde-apps/libkonq-9999
	=kde-apps/libkcddb-9999
	=kde-apps/okular-5.9999
	$(add_kdeapps_dep kdeadmin-meta)
	$(add_kdeapps_dep kdecore-meta)
	$(add_kdeapps_dep kdegraphics-meta)
	$(add_kdeapps_dep kdemultimedia-meta)
	$(add_kdeapps_dep kdeutils-meta)
	pim? ( =kde-apps/kdepim-meta-16.04.3 )
	sdk? ( $(add_kdeapps_dep kdesdk-meta) )
"
