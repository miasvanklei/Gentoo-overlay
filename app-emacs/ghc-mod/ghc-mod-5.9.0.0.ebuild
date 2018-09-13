# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.4

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3
LIVE_EBUILD=yes

DESCRIPTION="Happy Haskell Hacking"
HOMEPAGE="https://github.com/DanielG/ghc-mod"
EGIT_REPO_URI="https://github.com/alanz/ghc-mod.git"
EGIT_BRANCH="ghc-8.6-parse-module"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="shelltest"

RDEPEND="dev-haskell/cabal-helper:=[profile?]
	>=dev-haskell/extra-1.6:=[profile?] <dev-haskell/extra-1.7:=[profile?]
	>=dev-haskell/fclabels-2.0:=[profile?] <dev-haskell/fclabels-2.1:=[profile?]
	>=dev-haskell/ghc-mod-core-5.9.0.0:=[profile?] <dev-haskell/ghc-mod-core-5.10.0.0:=[profile?]
	>=dev-haskell/ghc-paths-0.1.0.9:=[profile?] <dev-haskell/ghc-paths-0.2:=[profile?]
	>=dev-haskell/haskell-src-exts-1.18:=[profile?] <dev-haskell/haskell-src-exts-1.21:=[profile?]
	>=dev-haskell/hlint-2.0.8:=[profile?] <dev-haskell/hlint-2.2:=[profile?]
	>=dev-haskell/monad-control-1:=[profile?] <dev-haskell/monad-control-1.1:=[profile?]
	>=dev-haskell/monad-journal-0.4:=[profile?] <dev-haskell/monad-journal-0.9:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/old-time:=[profile?]
	>=dev-haskell/optparse-applicative-0.14.0.0:=[profile?] <dev-haskell/optparse-applicative-0.15:=[profile?]
	>=dev-haskell/pipes-4.1:=[profile?] <dev-haskell/pipes-4.4:=[profile?]
	>=dev-haskell/safe-0.3.9:=[profile?] <dev-haskell/safe-0.4:=[profile?]
	>=dev-haskell/semigroups-0.10.0:=[profile?] <dev-haskell/semigroups-0.19:=[profile?]
	>=dev-haskell/split-0.2.2:=[profile?] <dev-haskell/split-0.3:=[profile?]
	>=dev-haskell/syb-0.5.1:=[profile?] <dev-haskell/syb-0.8:=[profile?]
	>=dev-haskell/temporary-1.2.0.3:=[profile?] <dev-haskell/temporary-1.3:=[profile?]
	>=dev-haskell/text-1.2.1.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/transformers-base-0.4.4:=[profile?] <dev-haskell/transformers-base-0.5:=[profile?]
	>=dev-lang/ghc-7.8.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24
	test? ( >=dev-haskell/doctest-0.9.3 <dev-haskell/doctest-0.12
		>=dev-haskell/hspec-2.0.0 <dev-haskell/hspec-2.4 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag shelltest shelltest)
}
