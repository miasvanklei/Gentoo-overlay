# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="The Package Manager for the Swift Programming Language"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-package-manager.git"
#EGIT_COMMIT="1b87a3651b0dcd7226f7214f445c6f5a92201f4f"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-libs/corelibs-foundation
        dev-libs/corelibs-xctest
	dev-python/lit
	dev-util/llbuild"
DEPEND="${RDEPEND}"

src_prepare()
{
	eapply ${FILESDIR}/fix-build.patch
	eapply_user
}

src_install() {
	./Utilities/bootstrap install \
	--swiftc /usr/bin/swiftc \
	--sbt /usr/bin/swift-build-tool \
	--prefix ${D}/usr \
	--verbose || die
	rm ${D}/usr/libexec
}
