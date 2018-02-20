# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.4

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3
LIVE_EBUILD=yes

DESCRIPTION="Provide a common engine to power any Haskell IDE"
HOMEPAGE="https://github.com/githubuser/haskell-ide-engine"
EGIT_REPO_URI="https://github.com/haskell/haskell-ide-engine.git"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="pedantic"

RDEPEND=">=app-emacs/ghc-mod-5.9.0.0:=[profile?]
	dev-haskell/aeson:=[profile?]
	dev-haskell/apply-refact:=[profile?]
	dev-haskell/async:=[profile?]
	dev-haskell/brittany:=[profile?]
	>=dev-haskell/cabal-1.22:=[profile?]
	dev-haskell/cabal-helper:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/diff:=[profile?]
	dev-haskell/ekg:=[profile?]
	dev-haskell/extra:=[profile?]
	dev-haskell/ghc-exactprint:=[profile?]
	>=dev-haskell/gitrev-1.1:=[profile?]
	dev-haskell/haddock-api:=[profile?]
	dev-haskell/haddock-library:=[profile?]
        dev-haskell/HaRe:=[profile?]
	dev-haskell/hie-plugin-api:=[profile?]
	>=dev-haskell/haskell-lsp-0.2:=[profile?]
	dev-haskell/haskell-src-exts:=[profile?]
	>=dev-haskell/hlint-2.0.9:=[profile?]
	>=dev-haskell/hoogle-5.0.13:=[profile?]
	dev-haskell/hslogger:=[profile?]
	>=dev-haskell/lens-4.14:=[profile?]
	dev-haskell/monad-control:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/optparse-simple-0.0.3:=[profile?]
	>=dev-haskell/sorted-list-0.2.0.0:=[profile?]
	dev-haskell/stm:=[profile?]
	dev-haskell/tagsoup:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/vector:=[profile?]
	dev-haskell/yaml:=[profile?]
	dev-haskell/yi-rope:=[profile?]
	>=dev-lang/ghc-8.0.1:=[profile?]
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24.0.0
	test? ( dev-haskell/hspec
		dev-haskell/quickcheck
		dev-haskell/quickcheck-instances
		dev-haskell/unordered-containers )
"
PATCHES=(
	"${FILESDIR}/older-cabal.patch"
)

src_prepare() {
        default
        cabal_chdeps \
                'hlint >= 2.0.11' \
                'hlint >= 2.0.9' \
                'cabal-helper >= 0.8.0.2' \
                'cabal-helper >= 0.7'
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag pedantic pedantic)
}
