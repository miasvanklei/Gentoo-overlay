# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/dlang-community/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

inherit bash-completion-r1

CONTAINERS="116a02872039efbd0289828cd5eeff6f60bdf539"
LIBDPARSE="86c9bf44c96e1666eb175c749cc26f62c2008979"
MSGPACK="480f3bf9ee80ccf6695ed900cfcc1850ba8da991"
MY_PV="$(ver_rs 3 '-' $(ver_cut 1-4)).$(ver_cut 5)"
SRC_URI="
	https://github.com/dlang-community/DCD/archive/v${MY_PV}.tar.gz -> DCD-${PV}.tar.gz
	https://github.com/economicmodeling/containers/archive/${CONTAINERS}.tar.gz -> containers-${CONTAINERS}.tar.gz
	https://github.com/dlang-community/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/msgpack/msgpack-d/archive/${MSGPACK}.tar.gz -> msgpack-d-${MSGPACK}.tar.gz
	"
S="${WORKDIR}/DCD-${MY_PV}"

src_prepare() {
	# Default ebuild unpack function places archives side-by-side ...
	mv -T ../containers-${CONTAINERS}    containers            || die
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
