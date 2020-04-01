# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.4

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal git-r3

DESCRIPTION="Source code suggestions"
HOMEPAGE="https://github.com/ndmitchell/hlint#readme"
EGIT_REPO_URI="https://github.com/ndmitchell/hlint.git"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ghc-lib +gpl +threaded"

RDEPEND=">=dev-haskell/aeson-1.1.2.0:=[profile?]
	>=dev-haskell/ansi-terminal-0.6.2:=[profile?]
	>=dev-haskell/cmdargs-0.10:=[profile?]
	>=dev-haskell/cpphs-1.20.1:=[profile?]
	>=dev-haskell/data-default-0.3:=[profile?]
	>=dev-haskell/extra-1.7.1:=[profile?]
	dev-haskell/file-embed:=[profile?]
	>=dev-haskell/filepattern-0.1.1:=[profile?]
	>=dev-haskell/refact-0.3:=[profile?]
	dev-haskell/text:=[profile?]
	>=dev-haskell/uniplate-1.5:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	dev-haskell/vector:=[profile?]
	>=dev-haskell/yaml-0.5.0:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	ghc-lib? (
		>=dev-haskell/ghc-lib-parser-8.10:=[profile?] <dev-haskell/ghc-lib-parser-8.11:=[profile?]
		>=dev-haskell/ghc-lib-parser-ex-8.10.0.2:=[profile?] <dev-haskell/ghc-lib-parser-ex-8.10.1:=[profile?]
	)
	!ghc-lib? (
		>=dev-lang/ghc-8.10:= <dev-lang/ghc-8.11:=
	)
	gpl? ( >=dev-haskell/hscolour-1.21:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag ghc-lib ghc-lib) \
		$(cabal_flag gpl gpl) \
		$(cabal_flag threaded threaded)
}
