# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Haxe - The Cross-Platform Toolkit"
HOMEPAGE="https://github.com/HaxeFoundation/haxe"
SRC_URI=""
EGIT_REPO_URI="https://github.com/HaxeFoundation/haxe.git"
EGIT_COMMIT=${PV}

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE=""

RDEPEND=""
DEPEND="
	dev-lang/ocaml[ocmalopt]
	dev-lang/neko
	dev-libs/libpcre
	sys-libs/zlib
	dev-ml/camlp4[ocamlopt]
${RDEPEND}"

MAKEOPTS="-j1"
