# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit eutils git-r3

EGIT_REPO_URI="https://github.com/jjk-jacky/pam_rundir.git"

LICENSE="LGPL-2 GPL-2"
SLOT="0"

src_prepare() {
        epatch "${FILESDIR}"/fix-comparison.patch
}

src_configure()
{
	${S}/configure \
	--prefix=/usr \
	--securedir=/lib64/security
}
