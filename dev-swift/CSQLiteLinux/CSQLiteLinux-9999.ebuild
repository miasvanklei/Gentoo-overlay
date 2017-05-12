# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="C module map for SQLite"
HOMEPAGE="https://github.com/vapor-community/csqlite"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vapor-community/csqlite.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p ${D}/usr/lib/swift/CSQLiteLinux || die
	cp module.modulemap ${D}/usr/lib/swift/CSQLiteLinux || die
}
