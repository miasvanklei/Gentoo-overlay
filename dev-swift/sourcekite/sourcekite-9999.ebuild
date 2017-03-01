# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="the backend of SDE's language server"
HOMEPAGE="https://github.com/jinmingjian/sourcekite"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jinmingjian/sourcekite.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"

src_prepare() {
        eapply_user
}

src_compile() {
	swift build --verbose \
	-c release \
	-Xlinker -lsourcekitdInProc \
	-Xlinker -lsourcekitdAPI || die
}

src_install() {
	dobin .build/release/sourcekite
}
