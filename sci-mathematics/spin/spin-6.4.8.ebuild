# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools

DESCRIPTION="HOL4 interactive proof assistant for higher order logic"
HOMEPAGE="Tool for the formal verification of distributed software systems"
SRC_URI="https://spinroot.com/${PN}/Src/${PN}${PV//./}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Spin/Src${PV}"

src_compile() {
	emake
}

src_install() {
	dobin spin
        doman ../Man/spin.1
	dodoc -r ../Doc
}
