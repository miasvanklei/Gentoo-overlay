# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.6

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit git-r3 haskell-cabal

DESCRIPTION="Hlint integration plugin with Haskell Language Server"
HOMEPAGE="http://hackage.haskell.org/package/hls-hlint-plugin"
EGIT_REPO_URI="https://github.com/haskell/haskell-language-server.git"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ghc-lib pedantic"

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/apply-refact:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/diff:=[profile?]
	dev-haskell/extra:=[profile?]
	app-emacs/ghcide:=[profile?]
	dev-haskell/hashable:=[profile?]
	dev-haskell/haskell-lsp:=[profile?]
	>=dev-haskell/hlint-3.2:=[profile?]
	dev-haskell/hls-plugin-api:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/lens:=[profile?]
	dev-haskell/regex-tdfa:=[profile?]
	dev-haskell/shake:=[profile?]
	dev-haskell/temporary:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-lang/ghc:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	ghc-lib? (
		>=dev-haskell/ghc-lib-8.10.2.20200916:=[profile?] <dev-haskell/ghc-lib-8.11:=[profile?]
		>=dev-haskell/ghc-lib-parser-ex-8.10:=[profile?] <dev-haskell/ghc-lib-parser-ex-8.11:=[profile?]
	)
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2
"

S="${WORKDIR}/${P}/plugins/${PN}"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag ghc-lib ghc-lib) \
		$(cabal_flag pedantic pedantic)
}
