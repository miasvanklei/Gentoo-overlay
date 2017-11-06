# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Swift Auto Completions for any Text Editor"
HOMEPAGE="https://github.com/terhechte/SourceKittenDaemon.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/terhechte/SourceKittenDaemon.git"
EGIT_BRANCH="less-dependencies"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation
	dev-swift/Commandant
	dev-swift/SourceKitten
	dev-swift/Embassy
	dev-swift/FileSystemWatcher
	dev-swift/XcodeEdit"
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/remove-dependencies.patch
)

src_compile() {
	swift build -c release \
	-Xlinker -lCommandant \
	-Xlinker -lSourceKittenFramework \
	-Xlinker -lEmbassy \
	-Xlinker -lXcodeEdit \
	-Xlinker -lFileSystemWatcher \
	--verbose || die
}

src_install() {
	newbin .build/release/sourcekittend SourceKittenDaemon
}
