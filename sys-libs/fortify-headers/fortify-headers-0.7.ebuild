# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.2f30.org/fortify-headers"
	inherit git-2
else
	SRC_URI="http://git.2f30.org/fortify-headers/snapshot/fortify-headers-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
fi

DESCRIPTION="A standalone implementation of fortify source."
HOMEPAGE="http://git.2f30.org/fortify-headers/"

LICENSE="ISC"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	local crtdir=$(${CC} -print-file-name= 2>/dev/null)
	sed -i -e "s|^PREFIX = /usr/local|PREFIX = ${crtdir}|g" Makefile
	sed -i -e "s|include/fortify|include|g" Makefile
	export DESTDIR="${D}"
}
