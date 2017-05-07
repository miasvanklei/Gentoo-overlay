# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Package Manager for the Swift Programming Language"
HOMEPAGE="http://llvm.org/"
SRC_URI="https://github.com/apple/${PN}/archive/swift-${PV}-RELEASE.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/swift
	dev-libs/corelibs-foundation
        dev-libs/corelibs-xctest
	dev-util/llbuild"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-swift-${PV}-RELEASE

PATCHES=(
	${FILESDIR}/musl.patch
)
src_install() {
	./Utilities/bootstrap install \
	--swiftc /usr/bin/swiftc \
	--sbt /usr/bin/swift-build-tool \
	--prefix ${D}/usr \
	--release \
	--verbose || die
	rm -r ${D}/usr/libexec
}
