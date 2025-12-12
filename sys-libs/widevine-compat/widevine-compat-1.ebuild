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

src_compile() {
	"${CC}" -Wl,-soname,libwidevine_compat.so.1 -shared "${FILESDIR}"/widevine-compat.c -o libwidevine_compat.so.1 || die
}

src_install() {
	dolib.so libwidevine_compat.so.1
}
