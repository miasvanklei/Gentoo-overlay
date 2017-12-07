# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dfmt is a formatter for D source code"
HOMEPAGE="https://github.com/Hackerpilot/dfmt"
LIBDPARSE="eb8309c9cd4272ec130c13d7f1addafe2b03edec"
SRC_URI="
	https://github.com/dlang-community/dfmt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dlang-community/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="net-misc/curl
	dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_prepare() {
	# Default ebuild unpack function places archives side-by-side ...
	mv -T "../libdparse-${LIBDPARSE}" libdparse || die
	eapply_user
}

src_compile() {
	emake ldc
}

src_install() {
	dobin bin/dfmt
	dodoc README.md
}
