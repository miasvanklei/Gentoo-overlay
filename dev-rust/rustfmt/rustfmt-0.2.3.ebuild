# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Format Rust code"
HOMEPAGE="https://github.com/rust-lang-nursery/rustfmt"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
SRC_URI="https://github.com/rust-lang-nursery/${PN}/archive/nightly-${PV}.tar.gz -> ${P}.tar.gz"

COMMON_DEPEND="dev-lang/rustc"
DEPEND="${COMMON_DEPEND}
	dev-util/cargo"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}/${PN}-nightly-${PV}

src_compile() {
	cargo build --release --verbose || die
}

src_install() {
	dobin target/release/rustfmt
}
