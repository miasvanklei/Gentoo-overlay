# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://kde.org/applications/utilities https://utils.kde.org"

LICENSE="metapackage"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="7zip cups floppy gpg lrz plasma rar webengine"

RDEPEND="
	>=app-cdr/dolphin-plugins-mountiso-${PV}:${SLOT}
	>=kde-apps/ark-${PV}:${SLOT}
	>=kde-apps/kate-${PV}:${SLOT}
	>=kde-apps/kcalc-${PV}:${SLOT}
	>=kde-apps/kcharselect-${PV}:${SLOT}
	>=kde-apps/kdebugsettings-${PV}:${SLOT}
	>=kde-apps/kwalletmanager-${PV}:${SLOT}
	>=kde-misc/kweather-${PV}:${SLOT}
	>=kde-misc/markdownpart-${PV}:${SLOT}
	plasma? ( >=kde-misc/kclock-${PV} )
"
#	floppy? ( >=kde-apps/kfloppy-${PV}:${SLOT} )
#	gpg? ( >=kde-apps/kgpg-${PV}:${SLOT} )
#	webengine? (
#		>=app-editors/ghostwriter-${PV}
#		>=kde-apps/kimagemapeditor-${PV}:${SLOT}
#	)


# Optional runtime deps: kde-apps/ark
RDEPEND="${RDEPEND}
	7zip? ( app-arch/p7zip )
	lrz? ( app-arch/lrzip )
	rar? ( || (
		app-arch/rar
		app-arch/unrar
		app-arch/unar
	) )
"
