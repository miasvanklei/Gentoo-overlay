# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="The Package Manager for the Swift Programming Language"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/apple/swift-package-manager.git"

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
	eapply ${FILESDIR}/fix-opaque.patch
	eapply ${FILESDIR}/fix-debug.patch
	eapply_user
}

src_install() {
	./Utilities/bootstrap install \
	--swiftc /usr/bin/swiftc \
	--sbt /usr/bin/swift-build-tool \
	--prefix ${D}/usr \
	--release \
	--verbose || die
	rm ${D}/usr/libexec
}
