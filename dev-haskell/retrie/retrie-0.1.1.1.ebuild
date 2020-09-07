# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.6

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A powerful, easy-to-use codemodding tool for Haskell"
HOMEPAGE="https://github.com/facebookincubator/retrie"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="buildexecutable"

RDEPEND=">=dev-haskell/ansi-terminal-0.10.3:=[profile?] <dev-haskell/ansi-terminal-0.11:=[profile?]
	>=dev-haskell/async-2.2.2:=[profile?] <dev-haskell/async-2.3:=[profile?]
	>=dev-haskell/data-default-0.7.1:=[profile?] <dev-haskell/data-default-0.8:=[profile?]
	>=dev-haskell/ghc-exactprint-0.6.2:=[profile?] <dev-haskell/ghc-exactprint-0.7:=[profile?]
	>=dev-haskell/mtl-2.2.2:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/optparse-applicative-0.15.1:=[profile?] <dev-haskell/optparse-applicative-0.16:=[profile?]
	>=dev-haskell/random-shuffle-0.0.4:=[profile?] <dev-haskell/random-shuffle-0.1:=[profile?]
	>=dev-haskell/syb-0.7.1:=[profile?] <dev-haskell/syb-0.8:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/unordered-containers-0.2.10:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-lang/ghc-8.4:=[profile?] <dev-lang/ghc-8.12:=[profile?]
	>=dev-lang/ghc-8.4.3:=
	buildexecutable? ( >=dev-haskell/haskell-src-exts-1.23.0:=[profile?] <dev-haskell/haskell-src-exts-1.24:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( dev-haskell/ghc-paths
		dev-haskell/hunit
		dev-haskell/tasty
		dev-haskell/tasty-hunit
		dev-haskell/temporary
		!buildexecutable? ( >=dev-haskell/haskell-src-exts-1.23.0 <dev-haskell/haskell-src-exts-1.24 ) )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag buildexecutable buildexecutable)
}
