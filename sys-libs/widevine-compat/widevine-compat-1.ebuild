# Copyright 1999-2025 Gentoo Authors
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

get_soname() {
	if use arm64; then
		echo "aarch64.so.1"
	elif use amd64; then
		echo "x86-64.so.2"
	fi
}

src_compile() {
	# widevine links uncessary to ld-linux-${arch}.so, reuse library to provide missing
	# symbols which aren't available in musl libc
	"${CC}" -shared "${FILESDIR}"/widevine-compat.c -o ld-linux-$(get_soname) || die
}

src_install() {
	dolib.so ld-linux-$(get_soname)
}
