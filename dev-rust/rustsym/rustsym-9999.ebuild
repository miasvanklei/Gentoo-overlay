# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3

DESCRIPTION="A tool to query symbols from rust code for use in IDEs"
HOMEPAGE="https://github.com/trixnz/rustsym"
EGIT_REPO_URI="https://github.com/trixnz/rustsym.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="dev-lang/rustc"
DEPEND="${COMMON_DEPEND}
	dev-util/cargo"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	cargo build --release --verbose || die
}

src_install() {
	dobin target/release/rustsym
}
