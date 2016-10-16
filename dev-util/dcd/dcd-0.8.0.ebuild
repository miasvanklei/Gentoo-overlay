# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="systemd"

CONTAINERS="c9853bbca9f0840df32a46edebbb9b17c8216cd4"
DSYMBOL="f6aac6cab1ffebdc2a56321f0c5fed2c896f38c4"
LIBDPARSE="516a053c9b16d05aee30d2606a88b7f815cd55df"
MSGPACK="878fcb1852160d1c3d206df933f6becba18aa222"

SRC_URI="
	https://github.com/Hackerpilot/DCD/archive/v${PV}.tar.gz -> DCD-${PV}.tar.gz
	https://github.com/economicmodeling/containers/archive/${CONTAINERS}.tar.gz -> containers-${CONTAINERS}.tar.gz
	https://github.com/Hackerpilot/dsymbol/archive/${DSYMBOL}.tar.gz -> dsymbol-${DSYMBOL}.tar.gz
	https://github.com/Hackerpilot/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/msgpack/msgpack-d/archive/${MSGPACK}.tar.gz -> msgpack-d-${MSGPACK}.tar.gz
	"
S="${WORKDIR}/DCD-${PV}"

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

inherit systemd

src_prepare()
{
#	eapply ${FILESDIR}/fix-compile.patch
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
