# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="Libpurple (Pidgin) plugin for using a Telegram account"
HOMEPAGE="https://github.com/majn/${PN}"
SRC_URI=""
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+libwebp"

DEPEND="net-im/pidgin
	dev-libs/openssl
	libwebp? ( media-libs/libwebp )
	"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable libwebp) || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
}
