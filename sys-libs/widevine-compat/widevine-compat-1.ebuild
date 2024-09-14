# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~amd64 ~arm ~arm64"
SLOT=0
IUSE=""

DESCRIPTION="compat library for missing symbols in musl specifically for widevine"

S="${WORKDIR}"

src_compile() {
	# widevine links uncessary to ld-linux-x86-64.so.2, reuse library to provide missing
        # symbols which aren't available in musl libc
	"${CC}" -shared "${FILESDIR}"/widevine-compat.c -o ld-linux-x86-64.so.2
}

src_install() {
	dosym /lib/libunwind.so.1 /lib/libgcc_so.1
	dolib.so ld-linux-x86-64.so.2
}
