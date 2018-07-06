# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.4

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal git-r3
LIVE_EBUILD=yes

DESCRIPTION="Simple interface to some of Cabal's configuration state used by ghc-mod"
HOMEPAGE="http://hackage.haskell.org/package/cabal-helper"
EGIT_REPO_URI="https://github.com/alanz/cabal-helper.git"
EGIT_BRANCH="bump-version-0.8.0.4"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-haskell/exceptions-0.8.3:=[profile?] <dev-haskell/exceptions-0.11:=[profile?]
	>=dev-haskell/mtl-2.0:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/semigroupoids-5.2:=[profile?] <dev-haskell/semigroupoids-5.3:=[profile?]
	>=dev-haskell/temporary-1.2.0.4:=[profile?] <dev-haskell/temporary-1.3:=[profile?]
	>=dev-haskell/unix-compat-0.4.3.1:=[profile?] <dev-haskell/unix-compat-0.7:=[profile?]
	>=dev-haskell/utf8-string-1.0.1.1:=[profile?] <dev-haskell/utf8-string-1.1:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	>=dev-haskell/cabal-1.18.1.3:=[profile?]
	|| ( ( <dev-haskell/cabal-1.26 )
		( >=dev-haskell/cabal-2.0 <dev-haskell/cabal-2.3 ) )
"
DEPEND="${RDEPEND}"
