# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit git-r3 haskell-cabal

DESCRIPTION="Haskell source code formatter"
HOMEPAGE="https://github.com/lspitzner/brittany/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/lspitzner/brittany.git"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="brittany-dev-lib"

RDEPEND=">=dev-haskell/aeson-1.0.1.0:=[profile?] <dev-haskell/aeson-1.5:=[profile?]
	>=dev-haskell/butcher-1.3.1:=[profile?] <dev-haskell/butcher-1.4:=[profile?]
	>=dev-haskell/cmdargs-0.10.14:=[profile?] <dev-haskell/cmdargs-0.11:=[profile?]
	>=dev-haskell/czipwith-1.0.1.0:=[profile?] <dev-haskell/czipwith-1.1:=[profile?]
	dev-haskell/data-tree-print:=[profile?]
	>=dev-haskell/extra-1.4.10:=[profile?] <dev-haskell/extra-1.7:=[profile?]
	>=dev-haskell/ghc-exactprint-0.5.8:=[profile?] <dev-haskell/ghc-exactprint-0.6.3:=[profile?]
	>=dev-haskell/ghc-paths-0.1.0.9:=[profile?] <dev-haskell/ghc-paths-0.2:=[profile?]
	>=dev-haskell/monad-memo-0.4.1:=[profile?] <dev-haskell/monad-memo-0.6:=[profile?]
	>=dev-haskell/mtl-2.2.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/multistate-0.7.1.1:=[profile?] <dev-haskell/multistate-0.9:=[profile?]
	>=dev-haskell/neat-interpolation-0.3.2:=[profile?] <dev-haskell/neat-interpolation-0.4:=[profile?]
	>=dev-haskell/random-1.1:=[profile?] <dev-haskell/random-1.2:=[profile?]
	>=dev-haskell/safe-0.3.9:=[profile?] <dev-haskell/safe-0.4:=[profile?]
	>=dev-haskell/semigroups-0.18.2:=[profile?] <dev-haskell/semigroups-0.19:=[profile?]
	>=dev-haskell/strict-0.3.2:=[profile?] <dev-haskell/strict-0.4:=[profile?]
	>=dev-haskell/syb-0.6:=[profile?] <dev-haskell/syb-0.8:=[profile?]
	>=dev-haskell/text-1.2:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/uniplate-1.6.12:=[profile?] <dev-haskell/uniplate-1.7:=[profile?]
	>=dev-haskell/unsafe-0.0:=[profile?] <dev-haskell/unsafe-0.1:=[profile?]
	>=dev-haskell/yaml-0.8.18:=[profile?] <dev-haskell/yaml-0.12:=[profile?]
	>=dev-lang/ghc-8.0.2:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24.2.0
	test? ( >=dev-haskell/hspec-2.4.1 <dev-haskell/hspec-2.8
		>=dev-haskell/parsec-3.1.11 <dev-haskell/parsec-3.2 )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag brittany-dev-lib brittany-dev-lib)
}
