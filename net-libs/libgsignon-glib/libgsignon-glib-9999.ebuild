# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools bzr vala

DESCRIPTION="GLib-based client library for applications handling account authentication through the Online Accounts Single Sign-On service"
HOMEPAGE="https://launchpad.net/libgsignon-glib"
EBZR_REPO_URI="lp:libgsignon-glib"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+vala"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	use vala && vala_src_prepare
	eautoreconf
}

src_configure() {
	econf \
	$(use_enable vala)
}
