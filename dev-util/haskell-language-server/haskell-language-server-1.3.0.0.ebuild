# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.7.9999
#hackport: flags: class:hls_plugins_class,eval:hls_plugins_eval,hlint:hls_plugins_hlint,haddockcomments:hls_plugins_haddock-comments,importlens:hls_plugins_import-lens,modulename:hls_plugins_module-name,pragmas:hls_plugins_pragmas,refineImports:hls_plugins_refine-imports,retrie:hls_plugins_retrie,splice:hls_plugins_splice,tactic:hls_plugins_tactic,brittany:hls_formatters_brittany,floskell:hls_formatters_floskell,fourmolu:hls_formatters_fourmolu,ormolu:hls_formatters_ormolu,stylishhaskell:hls_formatters_stylish-haskell,-pedantic,-all-plugins,-all-formatters

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit git-r3 haskell-cabal
RESTRICT="test" # Missing files

DESCRIPTION="LSP server for GHC"
HOMEPAGE="https://github.com/haskell/haskell-language-server#readme"
EGIT_REPO_URI="https://github.com/haskell/haskell-language-server.git"
EGIT_COMMIT="1.3.0"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

IUSE_HLS_PLUGINS="
	+hls_plugins_call_hierarchy
	+hls_plugins_class
	+hls_plugins_eval
	+hls_plugins_hlint
	+hls_plugins_haddock-comments
	+hls_plugins_import-lens
	+hls_plugins_module-name
	+hls_plugins_pragmas
	+hls_plugins_refine-imports
	+hls_plugins_retrie
	+hls_plugins_splice
	+hls_plugins_tactic
"

IUSE_HLS_FORMATTERS="
	+hls_formatters_brittany
	+hls_formatters_floskell
	+hls_formatters_fourmolu
	+hls_formatters_ormolu
	+hls_formatters_stylish-haskell
"

IUSE="${IUSE_HLS_PLUGINS} ${IUSE_HLS_FORMATTERS}"

RDEPEND="dev-haskell/aeson:=[profile?]
	dev-haskell/aeson-pretty:=[profile?]
	dev-haskell/async:=[profile?]
	dev-haskell/base16-bytestring:=[profile?]
	dev-haskell/cryptohash-sha1:=[profile?]
	dev-haskell/data-default:=[profile?]
	dev-haskell/extra:=[profile?]
	dev-haskell/ghc-api-compat:=[profile?]
	dev-haskell/ghc-paths:=[profile?]
	>=dev-haskell/ghcide-1.4:=[profile?] <dev-haskell/ghcide-1.5:=[profile?]
	dev-haskell/gitrev:=[profile?]
	dev-haskell/hashable:=[profile?]
	dev-haskell/hie-bios:=[profile?]
	dev-haskell/hiedb:=[profile?]
	dev-haskell/hls-graph:=[profile?]
	>=dev-haskell/hls-plugin-api-1.2:=[profile?] <dev-haskell/hls-plugin-api-1.3:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/lens:=[profile?]
	dev-haskell/lsp:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/optparse-applicative:=[profile?]
	dev-haskell/optparse-simple:=[profile?]
	dev-haskell/regex-tdfa:=[profile?]
	dev-haskell/safe-exceptions:=[profile?]
	dev-haskell/sqlite-simple:=[profile?]
	dev-haskell/temporary:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/unordered-containers:=[profile?]
	>=dev-lang/ghc-8.6.3:=
	hls_formatters_brittany? ( >=dev-haskell/hls-brittany-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-brittany-plugin-1.1:=[profile?] )
	hls_formatters_floskell? ( >=dev-haskell/hls-floskell-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-floskell-plugin-1.1:=[profile?] )
	hls_formatters_fourmolu? ( >=dev-haskell/hls-fourmolu-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-fourmolu-plugin-1.1:=[profile?] )
	hls_formatters_ormolu? ( >=dev-haskell/hls-ormolu-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-ormolu-plugin-1.1:=[profile?] )
	hls_formatters_stylish-haskell? ( >=dev-haskell/hls-stylish-haskell-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-stylish-haskell-plugin-1.1:=[profile?] )
	hls_plugins_call_hierarchy? ( >=dev-haskell/hls-call-hierarchy-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-call-hierarchy-plugin-1.1:=[profile?] )
	hls_plugins_class? ( >=dev-haskell/hls-class-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-class-plugin-1.1:=[profile?] )
	hls_plugins_eval? ( >=dev-haskell/hls-eval-plugin-1.1.0.0:=[profile?] <dev-haskell/hls-eval-plugin-1.2:=[profile?] )
	hls_plugins_haddock-comments? ( >=dev-haskell/hls-haddock-comments-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-haddock-comments-plugin-1.1:=[profile?] )
	hls_plugins_hlint? ( >=dev-haskell/hls-hlint-plugin-1.0.0.2:=[profile?] <dev-haskell/hls-hlint-plugin-1.1:=[profile?] )
	hls_plugins_import-lens? ( >=dev-haskell/hls-explicit-imports-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-explicit-imports-plugin-1.1:=[profile?] )
	hls_plugins_module-name? ( >=dev-haskell/hls-module-name-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-module-name-plugin-1.1:=[profile?] )
	hls_plugins_pragmas? ( >=dev-haskell/hls-pragmas-plugin-1.0.0.0:=[profile?] <dev-haskell/hls-pragmas-plugin-1.1:=[profile?] )
	hls_plugins_refine-imports? ( dev-haskell/hls-refine-imports-plugin:=[profile?] )
	hls_plugins_retrie? ( >=dev-haskell/hls-retrie-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-retrie-plugin-1.1:=[profile?] )
	hls_plugins_splice? ( >=dev-haskell/hls-splice-plugin-1.0.0.1:=[profile?] <dev-haskell/hls-splice-plugin-1.1:=[profile?] )
	hls_plugins_tactic? ( >=dev-haskell/hls-tactics-plugin-1.2.0.0:=[profile?] <dev-haskell/hls-tactics-plugin-1.3:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.4.0.1"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-all-formatters \
		--flag=-all-plugins \
		$(cabal_flag hls_plugins_call_hierarchy callHierarchy) \
		$(cabal_flag hls_formatters_brittany brittany) \
		$(cabal_flag hls_plugins_class class) \
		$(cabal_flag hls_plugins_eval eval) \
		$(cabal_flag hls_formatters_floskell floskell) \
		$(cabal_flag hls_formatters_fourmolu fourmolu) \
		$(cabal_flag hls_plugins_haddock-comments haddockcomments) \
		$(cabal_flag hls_plugins_hlint hlint) \
		$(cabal_flag hls_plugins_import-lens importlens) \
		$(cabal_flag hls_plugins_module-name modulename) \
		$(cabal_flag hls_formatters_ormolu ormolu) \
		--flag=-pedantic \
		$(cabal_flag hls_plugins_pragmas pragmas) \
		$(cabal_flag hls_plugins_refine-imports refineImports) \
		$(cabal_flag hls_plugins_retrie retrie) \
		$(cabal_flag hls_plugins_splice splice) \
		$(cabal_flag hls_formatters_stylish-haskell stylishhaskell) \
		$(cabal_flag hls_plugins_tactic tactic)
}
