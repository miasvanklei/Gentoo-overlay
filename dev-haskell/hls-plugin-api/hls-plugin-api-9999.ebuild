# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.6

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit git-r3 haskell-cabal

DESCRIPTION="Haskell Language Server API for plugin communication"
HOMEPAGE="https://github.com/haskell/haskell-language-server#readme"
EGIT_REPO_URI="https://github.com/haskell/haskell-language-server.git"
EGIT_SUBMODULES=()

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/diff:=[profile?]
	dev-haskell/extra:=[profile?]
	>=app-emacs/ghcide-0.1:=[profile?]
	>=dev-haskell/haskell-lsp-0.22:=[profile?] <dev-haskell/haskell-lsp-0.23:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/lens:=[profile?]
	>=dev-haskell/regex-tdfa-1.3.1.0:=[profile?]
	>=dev-haskell/shake-0.17.5:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	dev-lang/ghc:=[profile?]
	>=dev-lang/ghc-8.6.3:="
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.4.0.1
	test? ( dev-haskell/blaze-markup
		dev-haskell/haskell-lsp-types
		dev-haskell/hspec
		dev-haskell/hspec-core
		>=dev-haskell/lsp-test-0.11.0.4
		dev-haskell/stm
		dev-haskell/tasty
		>=dev-haskell/tasty-ant-xml-1.1.6
		dev-haskell/tasty-expected-failure
		dev-haskell/tasty-golden
		dev-haskell/tasty-hunit
		dev-haskell/tasty-rerun
		dev-haskell/yaml )
"

S="${WORKDIR}/${P}/hls-plugin-api"
