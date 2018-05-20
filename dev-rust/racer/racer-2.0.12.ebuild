# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Rust Code Completion utility "
HOMEPAGE="https://github.com/phildawes/racer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
SRC_URI="https://github.com/phildawes/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-lang/rust"
RDEPEND="${DEPEND}"

src_compile() {
	cargo build --release --verbose || die
}

src_install() {
	dobin target/release/racer
}
