# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency manager for the Crystal language"
HOMEPAGE="https://github.com/crystal-lang-tools/scry"
SRC_URI="https://github.com/crystal-lang-tools/scry/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>dev-lang/crystal-0.11.1[yaml]
"
RDEPEND="${DEPEND}"

RESTRICT=test # missing files in tarball

src_compile() {
	crystal build --release --progress --no-debug src/scry.cr
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
