# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="Rust Code Completion utility "
HOMEPAGE="https://github.com/phildawes/racer"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

EGIT_REPO_URI="https://github.com/phildawes/racer"

COMMON_DEPEND="dev-lang/rustc"
DEPEND="${COMMON_DEPEND}
	dev-util/cargo"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	cargo build --release --verbose || die
}

src_install() {
	dobin target/release/racer
}

pkg_postinst() {
	elog "You most probably build rust with the source flag for the best experience."
	elog "Racer will look for sources in path pointed by RUST_SRC_PATH"
	elog "environment variable. You can use"
	elog "% export RUST_SRC_PATH=<path to>/rust/src."
	elog "Use vim-racer or emacs-racer for the editos support"
	elog
}
