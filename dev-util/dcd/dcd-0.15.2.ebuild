# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/dlang-community/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

inherit bash-completion-r1

CONTAINERS="fc1625a5a0c253272b80addfb4107928495fd647"
DSYMBOL="f9a3d302527a9e50140991562648a147b6f5a78e"
LIBDPARSE="1393ee4d0c8e50011e641e06d64c429841fb3c2b"
MSGPACK="480f3bf9ee80ccf6695ed900cfcc1850ba8da991"
ALLOCATOR="d6e6ce4a838e0dad43ef13f050f96627339cdccd"
SRC_URI="
	https://github.com/dlang-community/DCD/archive/v${PV}.tar.gz -> DCD-${PV}.tar.gz
	https://github.com/economicmodeling/containers/archive/${CONTAINERS}.tar.gz -> containers-${CONTAINERS}.tar.gz
	https://github.com/dlang-community/dsymbol/archive/${DSYMBOL}.tar.gz -> dsymbol-${DSYMBOL}.tar.gz
	https://github.com/dlang-community/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/dlang-community/stdx-allocator/archive/${ALLOCATOR}.tar.gz -> stdx-allocator-${ALLOCATOR}.tar.gz
	https://github.com/msgpack/msgpack-d/archive/${MSGPACK}.tar.gz -> msgpack-d-${MSGPACK}.tar.gz
	"
S="${WORKDIR}/DCD-${PV}"

src_prepare() {
	# Default ebuild unpack function places archives side-by-side ...
	mv -T ../stdx-allocator-${ALLOCATOR} stdx-allocator/source || die
	mv -T ../containers-${CONTAINERS}    containers            || die
	mv -T ../dsymbol-${DSYMBOL}          dsymbol               || die
	mv -T ../libdparse-${LIBDPARSE}      libdparse             || die
	mv -T ../msgpack-d-${MSGPACK}        msgpack-d             || die

	# Stop makefile from executing git to write an unused githash.txt
	echo "v${PV}" > githash.txt || die "Could not generate githash"
	touch githash || die "Could not generate githash"

	default
}

src_compile() {
	local flags="-Icontainers/src -Idsymbol/src -Ilibdparse/src -Imsgpack-d/src -Isrc -J."

	emake \
		LDC_CLIENT_FLAGS="$flags" \
		LDC_SERVER_FLAGS="$flags" \
		ldc

	# Write system include paths of host compiler into dcd.conf
	ldc_system_imports > dcd.conf
}

ldc_system_imports() {
	echo "/usr/include/d"
	echo "/usr/include/d/ldc"
}

src_install() {
	dobin bin/dcd-server
	dobin bin/dcd-client

	dobashcomp bash-completion/completions/dcd-server
	dobashcomp bash-completion/completions/dcd-client

	insinto /etc
	doins dcd.conf
	dodoc README.md
	doman man1/dcd-client.1 man1/dcd-server.1
}
