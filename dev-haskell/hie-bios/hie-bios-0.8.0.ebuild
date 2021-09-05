# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit git-r3 haskell-cabal

DESCRIPTION="Set up a GHC API session"
HOMEPAGE="https://github.com/mpickering/hie-bios"
EGIT_REPO_URI="https://github.com/mpickering/hie-bios.git"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RESTRICT="test" # requires network access

RDEPEND=">=dev-haskell/aeson-1.4.5:=[profile?] <dev-haskell/aeson-2:=[profile?]
	>=dev-haskell/base16-bytestring-0.1.1:=[profile?] <dev-haskell/base16-bytestring-1.1:=[profile?]
	>=dev-haskell/conduit-1.3:=[profile?] <dev-haskell/conduit-2:=[profile?]
	>=dev-haskell/conduit-extra-1.3:=[profile?] <dev-haskell/conduit-extra-2:=[profile?]
	>=dev-haskell/cryptohash-sha1-0.11.100:=[profile?] <dev-haskell/cryptohash-sha1-0.12:=[profile?]
	>=dev-haskell/extra-1.6.14:=[profile?] <dev-haskell/extra-1.8:=[profile?]
	>=dev-haskell/file-embed-0.0.11:=[profile?] <dev-haskell/file-embed-1:=[profile?]
	>=dev-haskell/hslogger-1.2:=[profile?] <dev-haskell/hslogger-1.4:=[profile?]
	dev-haskell/optparse-applicative:=[profile?]
	>=dev-haskell/temporary-1.2:=[profile?] <dev-haskell/temporary-1.4:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/unix-compat-0.5.1:=[profile?] <dev-haskell/unix-compat-0.6:=[profile?]
	>=dev-haskell/unordered-containers-0.2.9:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-haskell/vector-0.12.0:=[profile?] <dev-haskell/vector-0.13:=[profile?]
	>=dev-haskell/yaml-0.10.0:=[profile?] <dev-haskell/yaml-0.12:=[profile?]
	>=dev-lang/ghc-8.4.1:=[profile?] <dev-lang/ghc-9.3:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( dev-haskell/hspec-expectations
		dev-haskell/tasty
		dev-haskell/tasty-expected-failure
		dev-haskell/tasty-hunit )
"
