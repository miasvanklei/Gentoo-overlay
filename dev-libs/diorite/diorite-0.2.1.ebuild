# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )
PYTHON_REQ_USE='threads(+)'

DESCRIPTION="Diorite Library is a utility and widget library for Nuvola Player project based on GLib, GIO and GTK."
HOMEPAGE="https://tiliado.eu/diorite"
SRC_URI="https://github.com/tiliado/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

inherit distutils-r1 waf-utils flag-o-matic vala

src_prepare() {
	epatch ${FILESDIR}/fix-stupid-options.patch
	vala_src_prepare
	eapply_user
}

src_configure() {
	# disable stack protector, crash otherwise
        append-cflags "-fno-stack-protector"
	python_setup
        waf-utils_src_configure
}
