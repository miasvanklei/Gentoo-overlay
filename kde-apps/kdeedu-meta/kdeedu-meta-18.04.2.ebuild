# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://edu.kde.org"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep analitza)
	$(add_kdeapps_dep cantor)
	$(add_kdeapps_dep kiten)
	$(add_kdeapps_dep marble)
	$(add_kdeapps_dep parley)
"
