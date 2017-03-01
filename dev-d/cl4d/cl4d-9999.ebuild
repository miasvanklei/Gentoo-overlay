# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="object-oriented wrapper for the OpenCL C API written in the D programming language"
HOMEPAGE="https://github.com/Trass3r/cl4d"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Trass3r/cl4d.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

DEPEND="dev-util/dub"
RDEPEND="${DEPEND}"

src_prepare()
{
	eapply ${FILESDIR}/shared.patch
	eapply ${FILESDIR}/beignet.patch
	eapply_user
}

src_compile() {
	dub build -b=release -c=cl4d || die
}

src_install() {
	dolib libcl4d.so
	insinto /usr/include/d/cl4d
	doins -r cl4d/*
}
