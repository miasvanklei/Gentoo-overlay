# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.7

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit git-r3 haskell-cabal

DESCRIPTION="Haddock comments generator plugin for Haskell Language Server"
HOMEPAGE="https://hackage.haskell.org/package/hls-haddock-comments-plugin"
SRC_URI=""
EGIT_REPO_URI="https://github.com/haskell/haskell-language-server.git"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/ghc-exactprint:=[profile?]
	app-emacs/ghcide:=[profile?]
	dev-haskell/haskell-lsp-types:=[profile?]
	dev-haskell/hls-plugin-api:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-lang/ghc:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2
"

S="${WORKDIR}/${P}/plugins/${PN}"
