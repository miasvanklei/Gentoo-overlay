# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="Library that parses Rust code for kdev-rust plugin"
HOMEPAGE="https://cgit.kde.org/scratch/egospodinova/ast-redux.git"
EGIT_REPO_URI="https://anongit.kde.org/scratch/egospodinova/ast-redux.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="dev-lang/rustc"
DEPEND="${COMMON_DEPEND}
	dev-util/cargo"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	RUSTFLAGS="-L/usr/lib/llvm/4/lib" cargo build --release --verbose || die
}

src_install() {
	dolib target/release/libast_redux.so
}
