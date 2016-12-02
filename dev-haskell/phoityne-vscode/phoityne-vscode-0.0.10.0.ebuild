# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# ebuild generated by hackport 0.5.1

CABAL_FEATURES=""
inherit haskell-cabal

DESCRIPTION="ghci debug viewer on Visual Studio Code"
HOMEPAGE="https://github.com/phoityne/phoityne-vscode"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/aeson:=
	dev-haskell/cabal:=
	dev-haskell/cmdargs:=
	dev-haskell/conduit:=
	dev-haskell/conduit-extra:=
	dev-haskell/configfile:=
	dev-haskell/fsnotify:=
	dev-haskell/hslogger:=
	dev-haskell/hstringtemplate:=
	dev-haskell/missingh:=
	dev-haskell/mtl:=
	dev-haskell/parsec:=
	dev-haskell/resourcet:=
	dev-haskell/safe:=
	dev-haskell/split:=
	dev-haskell/text:=
	>=dev-lang/ghc-7.8.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
"
