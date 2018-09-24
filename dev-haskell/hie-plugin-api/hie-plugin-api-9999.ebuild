# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.4

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal git-r3
LIVE_EBUILD=yes

DESCRIPTION="Provide a common engine to power any Haskell IDE"
HOMEPAGE="http://hackage.haskell.org/package/hie-plugin-api"
EGIT_REPO_URI="https://github.com/haskell/haskell-ide-engine.git"
EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="pedantic"

S=${S}/hie-plugin-api

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/constrained-dynamic:=[profile?]
	dev-haskell/diff:=[profile?]
	dev-haskell/fingertree:=[profile?]
	>=dev-haskell/ghc-mod-core-5.9.0.0:=[profile?]
	>=dev-haskell/haskell-lsp-types-0.2.1.0:=[profile?]
	>=dev-haskell/haskell-lsp-0.2.1.0:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/monad-control:=[profile?]
	dev-haskell/monoid-subclasses:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/stm:=[profile?]
	dev-haskell/syb:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	>=dev-lang/ghc-8.0.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24.0.0
"

PATCHES=(
	"${FILESDIR}"/ghc-8.6.patch
)

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag pedantic pedantic)
}
