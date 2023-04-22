# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="sign kernel"
KEYWORDS="~amd64 ~arm ~arm64"
SLOT=0
IUSE=""

RDEPEND="app-crypt/sbsigntools"

S=${WORKDIR}

src_install()
{
	exeinto /etc/kernel/postinst.d
	doexe ${FILESDIR}/sign-kernel.sh
}

