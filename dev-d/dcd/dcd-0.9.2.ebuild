# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Auto-complete program for the D programming language"
HOMEPAGE="https://github.com/Hackerpilot/DCD"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="systemd"

CONTAINERS="6c5504cc80b75192b24cebe93209521c03f806d8"
DSYMBOL="5b90412457ac5f1d67c04e4da01587edfd529ad5"
LIBDPARSE="ee0fa01ab74b6bf27bed3c7bdb9d6fb789963342"
MSGPACK="500940918243cf0468028e552605204c6aa46807"
STDXALLOCATOR="7487970b58f4a2c0d495679329a8a2857111f3fd"

SRC_URI="
	https://github.com/dlang-community/DCD/archive/v${PV}.tar.gz -> DCD-${PV}.tar.gz
	https://github.com/dlang-community/dsymbol/archive/${DSYMBOL}.tar.gz -> dsymbol-${DSYMBOL}.tar.gz
	https://github.com/dlang-community/libdparse/archive/${LIBDPARSE}.tar.gz -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/dlang-community/stdx-allocator/archive/${STDXALLOCATOR}.tar.gz -> stdx-allocator-${STDXALLOCATOR}.tar.gz
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
	mv -T ../stdx-allocator-${STDXALLOCATOR}      stdx-allocator                     || die

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
