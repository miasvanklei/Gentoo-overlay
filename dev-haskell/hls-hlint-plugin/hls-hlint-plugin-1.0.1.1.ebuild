# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Hlint integration plugin with Haskell Language Server"
HOMEPAGE="https://hackage.haskell.org/package/hls-hlint-plugin"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ghc-lib"

RDEPEND="dev-haskell/aeson:=[profile?]
	>=dev-haskell/apply-refact-0.9.3.0:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/diff-0.4.0:=[profile?] <dev-haskell/diff-0.5:=[profile?]
	dev-haskell/extra:=[profile?]
	>=dev-haskell/ghc-exactprint-0.6.3.4:=[profile?]
	>=dev-haskell/ghcide-1.4:=[profile?] <dev-haskell/ghcide-1.5:=[profile?]
	dev-haskell/hashable:=[profile?]
	>=dev-haskell/hls-plugin-api-1.1:=[profile?] <dev-haskell/hls-plugin-api-1.3:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/lens:=[profile?]
	dev-haskell/lsp:=[profile?]
	dev-haskell/regex-tdfa:=[profile?]
	dev-haskell/temporary:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	>=dev-lang/ghc-8.10:=
	ghc-lib? (
		>=dev-haskell/ghc-lib-9.0:=[profile?] <dev-haskell/ghc-lib-9.1:=[profile?]
		>=dev-haskell/ghc-lib-parser-ex-9.0:=[profile?] <dev-haskell/ghc-lib-parser-ex-9.1:=[profile?]
	)
	>=dev-haskell/hlint-3.3:=[profile?] <dev-haskell/hlint-3.4:=[profile?]
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.4.0.1
"

PATCHES=(
	"${FILESDIR}"/remove-ghc-api-compat.patch
)

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag ghc-lib ghc-lib) \
		--flag=hlint33 \
		--flag=-pedantic
}
