# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="systemd"

CONTAINERS="2892cfc1e7a205d4f81af3970cbb53e4f365a765"
DSYMBOL="e9aae0594739d002009cd34dd3edeb38f1f0893b"
LIBDPARSE="5e81535d0aff4ceec2cbf03f5b02a31ae6d3fec2"
MSGPACK="e6a5a69d2f86f2a0f7f7dad9de7080a55a929e46"

SRC_URI="
	https://github.com/Hackerpilot/DCD/archive/v${PV}.tar.gz -> DCD-${PV}.tar.gz
	https://github.com/Hackerpilot/dsymbol/archive/${DSYMBOL}.tar.gz -> dsymbol-${DSYMBOL}.tar.gz
	https://github.com/Hackerpilot/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/msgpack/msgpack-d/archive/${MSGPACK}.tar.gz -> msgpack-d-${MSGPACK}.tar.gz
        https://github.com/economicmodeling/containers/archive/${CONTAINERS}.tar.gz -> containers-${CONTAINERS}.tar.gz
	"
S="${WORKDIR}/DCD-${PV}"

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

inherit systemd

src_prepare()
{
	default
        mv -T ../containers-${CONTAINERS}            containers                        || die
	mv -T ../dsymbol-${DSYMBOL}                  dsymbol                           || die
	mv -T ../libdparse-${LIBDPARSE}              libdparse                         || die
	mv -T ../msgpack-d-${MSGPACK}                msgpack-d                         || die

	touch githash.txt || die "Could not generate githash"
	touch githash || die "Could not generate githash"
}

src_compile() {
	emake ldc
}

src_install() {
	dobin bin/dcd-server
	dobin bin/dcd-client
	use systemd && systemd_douserunit "${FILESDIR}"/dcd-server.service
	insinto /etc
	dodoc README.md
	doman man1/dcd-client.1 man1/dcd-server.1
}

pkg_postinst() {
	use systemd && elog "A systemd user service for 'dcd-server' has been installed."
}
