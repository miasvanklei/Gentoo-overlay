# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Package and build management system for D"
HOMEPAGE="https://code.dlang.org/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="debug"

GITHUB_URI="https://codeload.github.com/dlang"
SRC_URI="${GITHUB_URI}/${PN}/tar.gz/v${PV} -> ${PN}-${PV}.tar.gz"

DEPEND="net-misc/curl
	dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_compile()
{
	DMD=ldmd2 GITVER="v${PV}" ldc2 -run "${S}/build.d" || die

	${S}/bin/dub --compiler=ldc2 --single scripts/man/gen_man.d || die
}

src_install()
{
	dobin ${S}/bin/dub
	doman ${S}/scripts/man/*.1

	mkdir -p ${D}/usr/share/site-functions
	cp ${S}/scripts/zsh-completion/_dub ${D}/usr/share/site-functions
}
