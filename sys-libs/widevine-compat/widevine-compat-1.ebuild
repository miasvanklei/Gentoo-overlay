# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="compat library for missing symbols in musl specifically for widevine"

S="${WORKDIR}"

LICENSE="public-domain"
SLOT=0
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	|| (
		llvm-runtimes/libgcc
		sys-devel/gcc
	)
"

src_compile() {
	# widevine links uncessary to ld-linux-x86-64.so.2, reuse library to provide missing
	# symbols which aren't available in musl libc
	"${CC}" -shared "${FILESDIR}"/widevine-compat.c -o ld-linux-x86-64.so.2 || die
}

src_install() {
	dolib.so ld-linux-x86-64.so.2
}
