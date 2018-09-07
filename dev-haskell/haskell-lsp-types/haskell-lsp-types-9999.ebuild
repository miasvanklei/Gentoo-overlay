# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.4

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3

DESCRIPTION="Haskell library for the Microsoft Language Server Protocol"
HOMEPAGE="https://github.com/alanz/haskell-lsp"
EGIT_REPO_URI="https://github.com/alanz/haskell-lsp.git"
EGIT_COMMIT="ca04c038526542cfdfb3001737cd2c2cf5cffb02"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/aeson-1.0.0.0:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/hashable:=[profile?]
	dev-haskell/hslogger:=[profile?]
	>=dev-haskell/lens-4.15.2:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/parsec:=[profile?]
	>=dev-haskell/sorted-list-0.2.0:=[profile?] <dev-haskell/sorted-list-0.2.3:=[profile?]
	dev-haskell/stm:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-haskell/vector:=[profile?]
	dev-haskell/yi-rope:=[profile?]
	>=dev-lang/ghc-8.0.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24.0.0
	test? ( dev-haskell/hspec )
"
S=${WORKDIR}/${P}/haskell-lsp-types
