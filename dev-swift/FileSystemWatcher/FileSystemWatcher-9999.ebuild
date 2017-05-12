# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A swift library for observing changes in a file system using inotify"
HOMEPAGE="https://github.com/felix91gr/FileSystemWatcher.git"
SRC_URI=""
EGIT_REPO_URI="https://github.com/felix91gr/FileSystemWatcher.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libdispatch
        dev-lang/swift
	dev-util/swift-package-manager
	dev-libs/corelibs-foundation"
DEPEND="${RDEPEND}"


PATCHES=(
        ${FILESDIR}/install-lib.patch
)

src_compile() {
	swift build -c release \
	--verbose || die
}

src_install() {
        mkdir -p ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/*.swift* ${D}/usr/lib/swift/linux/x86_64 || die
        cp .build/release/lib* ${D}/usr/lib/swift/linux || die
        mkdir -p ${D}/usr/lib/swift/inotify || die
        find .build/checkouts -name module.modulemap -exec cp {} ${D}/usr/lib/swift/inotify \; || die
        sed -i -e 's|'${S}'/Sources/inotify/include|/usr/lib/swift/inotify|g' ${D}/usr/lib/swift/inotify/module.modulemap || die
        find .build/checkouts -name inotify_wrapper.h -exec cp {} ${D}/usr/lib/swift/inotify \; || die
}
