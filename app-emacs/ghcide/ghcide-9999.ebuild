# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit git-r3 haskell-cabal

DESCRIPTION="The core of an IDE"
HOMEPAGE="https://github.com/digital-asset/ghcide#readme"
EGIT_REPO_URI="https://github.com/digital-asset/ghcide.git"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ghc-lib"

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/async:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/extra:=[profile?]
        dev-haskell/fuzzy:=[profile?]
        >=dev-haskell/ghc-check-0.3.0.1:=[profile?]
        dev-haskell/ghc-paths:=[profile?]
	dev-haskell/haddock-library:=[profile?]
	dev-haskell/hashable:=[profile?]
	=dev-haskell/haskell-lsp-0.21.0.0:=[profile?]
	=dev-haskell/haskell-lsp-types-0.21.0.0:=[profile?]
	>=dev-haskell/hie-bios-0.4:=[profile?] <dev-haskell/hie-bios-0.5:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/network-uri:=[profile?]
	dev-haskell/optparse-applicative:=[profile?]
	dev-haskell/prettyprinter:=[profile?]
	dev-haskell/prettyprinter-ansi-terminal:=[profile?]
	>=dev-haskell/regex-tdfa-1.3.1.0:=[profile?]
	dev-haskell/rope-utf16-splay:=[profile?]
	dev-haskell/safe-exceptions:=[profile?]
	>=dev-haskell/shake-0.17.5:=[profile?]
	dev-haskell/sorted-list:=[profile?]
	dev-haskell/stm:=[profile?]
	dev-haskell/syb:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	ghc-lib? ( >=dev-haskell/ghc-lib-8.8:=[profile?]
			>=dev-haskell/ghc-lib-parser-8.8:=[profile?] )
	!ghc-lib? ( >=dev-lang/ghc-8.0.2:= )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24.2.0
	test? ( dev-haskell/lens
		>=dev-haskell/lsp-test-0.8
		dev-haskell/parser-combinators
		dev-haskell/tasty
		dev-haskell/tasty-expected-failure
		dev-haskell/tasty-hunit
		dev-haskell/text:=[profile?] )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag ghc-lib ghc-lib)
}
