# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Auto generate hie-bios cradles"
HOMEPAGE="https://github.com/Avi-D-coder/implicit-hie-cradle#readme"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-haskell/base16-bytestring-0.1.1:=[profile?] <dev-haskell/base16-bytestring-1.1:=[profile?]
	>=dev-haskell/extra-1.6.14:=[profile?] <dev-haskell/extra-1.8:=[profile?]
	>=dev-haskell/hie-bios-0.7.0:=[profile?]
	>=dev-haskell/hslogger-1.2:=[profile?] <dev-haskell/hslogger-1.4:=[profile?]
	>=dev-haskell/implicit-hie-0.1.2.5:=[profile?] <dev-haskell/implicit-hie-1:=[profile?]
	>=dev-haskell/temporary-1.2:=[profile?] <dev-haskell/temporary-1.4:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/unix-compat-0.5.1:=[profile?] <dev-haskell/unix-compat-0.6:=[profile?]
	>=dev-haskell/unordered-containers-0.2.9:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-haskell/vector-0.12.0:=[profile?] <dev-haskell/vector-0.13:=[profile?]
	>=dev-haskell/yaml-0.8.32:=[profile?] <dev-haskell/yaml-0.12:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
"
