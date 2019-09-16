# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit git-r3 haskell-cabal

DESCRIPTION="Provide a common engine to power any Haskell IDE"
HOMEPAGE="https://github.com/githubuser/haskell-ide-engine#readme"
SRC_URI=""
EGIT_REPO_URI="https://github.com/haskell/haskell-ide-engine.git"
EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="pedantic"

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/apply-refact:=[profile?]
	dev-haskell/async:=[profile?]
	dev-haskell/brittany:=[profile?]
	>=dev-haskell/cabal-1.22:=[profile?]
	>=dev-haskell/cabal-helper-0.8.0.4:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/diff:=[profile?]
	>=dev-haskell/floskell-0.10:=[profile?] <dev-haskell/floskell-0.11:=[profile?]
	dev-haskell/fold-debounce:=[profile?]
	dev-haskell/ghc-exactprint:=[profile?]
	=dev-haskell/ghc-mod-9999:=[profile?]
	=dev-haskell/ghc-mod-core-9999:=[profile?]
	>=dev-haskell/gitrev-1.1:=[profile?]
	=dev-haskell/hare-9999:=[profile?]
	=dev-haskell/haskell-lsp-0.15.0.0:=[profile?]
	=dev-haskell/haskell-lsp-types-0.15.0.0:=[profile?]
	dev-haskell/haskell-src-exts:=[profile?]
	dev-haskell/haddock-api:=[profile?]
	dev-haskell/haddock-library:=[profile?]
	dev-haskell/hie-plugin-api:=[profile?]
	>=dev-haskell/hlint-2.0.11:=[profile?] <dev-haskell/hlint-2.1.18:=[profile?]
	>=dev-haskell/hoogle-5.0.13:=[profile?]
	dev-haskell/hsimport:=[profile?]
	dev-haskell/hslogger:=[profile?]
	>=dev-haskell/lens-4.15.2:=[profile?]
	dev-haskell/lifted-async:=[profile?]
	dev-haskell/monad-control:=[profile?]
	>dev-haskell/monoid-subclasses-0.4:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/optparse-simple-0.0.3:=[profile?]
	dev-haskell/parsec:=[profile?]
	>=dev-haskell/rope-utf16-splay-0.3.1.0:=[profile?]
	dev-haskell/safe:=[profile?]
	>=dev-haskell/sorted-list-0.2.1.0:=[profile?]
	dev-haskell/stm:=[profile?]
	dev-haskell/tagsoup:=[profile?]
	dev-haskell/text:=[profile?]
	>=dev-haskell/unix-time-0.4.5:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-haskell/vector:=[profile?]
	dev-haskell/versions:=[profile?]
	>=dev-haskell/yaml-0.8.31:=[profile?]
	>=dev-lang/ghc-8.0.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.0
	test? ( dev-haskell/free
		>=dev-haskell/haskell-lsp-types-0.15.0.0
		dev-haskell/hie-test-utils
		>=dev-haskell/lsp-test-0.6.0.0
		dev-haskell/quickcheck
		dev-haskell/quickcheck-instances )
"

PATCHES=(
	"${FILESDIR}"/cabal.patch
	"${FILESDIR}"/hlint.patch
	"${FILESDIR}"/haddock.patch
	"${FILESDIR}"/disable-test-library.patch
)

src_prepare() {
	default

	cabal_chdeps \
		'unix-time >= 0.4.7' 'unix-time >= 0.4.5'
}


src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag pedantic pedantic)
x}
