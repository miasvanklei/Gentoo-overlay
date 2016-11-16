# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="The Package Manager for the Swift Programming Language"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-package-manager.git"
EGIT_COMMIT="973a3ad9892ceeed2327327f442dc4f2d1957843"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-devel/llvm
	dev-lang/swift
	dev-libs/corelibs-foundation
        dev-libs/corelib-xctest
	dev-util/lit
	dev-util/llbuild"
DEPEND="${RDEPEND}"

src_prepare()
{
	eapply ${FILESDIR}/fix-opaque.patch
	eapply_user
}

src_install() {
	dosym /usr/bin/${CC} ${S}/clang
	./Utilities/bootstrap install \
	--swiftc /usr/bin/swiftc \
	--sbt /usr/bin/swift-build-tool \
	--prefix ${D}/usr \
	--release || die
	rm ${D}/usr/libexec
}
