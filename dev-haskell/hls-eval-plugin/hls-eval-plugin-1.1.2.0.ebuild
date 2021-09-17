# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal
RESTRICT="test" # Requires a git repo that isn't included in the tarball

DESCRIPTION="Eval plugin for Haskell Language Server"
HOMEPAGE="https://hackage.haskell.org/package/hls-eval-plugin"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-haskell/aeson:=[profile?]
	>=dev-haskell/diff-0.4.0:=[profile?] <dev-haskell/diff-0.5:=[profile?]
	dev-haskell/dlist:=[profile?]
	dev-haskell/extra:=[profile?]
	dev-haskell/ghc-paths:=[profile?]
	>=dev-haskell/ghcide-1.2:=[profile?] <dev-haskell/ghcide-1.5:=[profile?]
	dev-haskell/hashable:=[profile?]
	>=dev-haskell/hls-plugin-api-1.1:=[profile?] <dev-haskell/hls-plugin-api-1.3:=[profile?]
	dev-haskell/lens:=[profile?]
	dev-haskell/lsp:=[profile?]
	dev-haskell/lsp-types:=[profile?]
	>=dev-haskell/megaparsec-9.0:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/parser-combinators:=[profile?]
	dev-haskell/pretty-simple:=[profile?]
	dev-haskell/quickcheck:2=[profile?]
	dev-haskell/safe-exceptions:=[profile?]
	dev-haskell/temporary:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unliftio:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	>=dev-lang/ghc-8.6.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.4.0.1
"

PATCHES=(
	"${FILESDIR}"/remove-ghc-api-compat.patch
)

src_configure() {
	haskell-cabal_src_configure \
		--flag=-pedantic
}
