# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.4.4.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit eutils git-r3 haskell-cabal

MY_PN="Top"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Constraint solving framework employed by the Helium Compiler"
HOMEPAGE="http://www.cs.uu.nl/wiki/bin/view/Helium/WebHome"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Helium4Haskell/Top.git"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/mtl:=[profile?]
	dev-haskell/parsec:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10.1.0
"
