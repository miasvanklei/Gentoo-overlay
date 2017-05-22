# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Swiss-army knife for D source code"
HOMEPAGE="https://github.com/Hackerpilot/Dscanner"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
ALLOCATOR="131739dce3038ccd6d762f3dd92d3718fbe5fc5f"
CONTAINERS="2892cfc1e7a205d4f81af3970cbb53e4f365a765"
DSYMBOL="d22c9714a60ac05cb32db938e81a396cffb5ffa6"
INIFILED="e4f63f126ddddb3e496574fec0f76b24e61b1d51"
LIBDPARSE="ca51bd13cf68646eaf9d6987db100cc3b288cffe"
GITHUB_URI="https://codeload.github.com"
SRC_URI="
	${GITHUB_URI}/Hackerpilot/experimental_allocator/tar.gz/${ALLOCATOR} -> experimental_allocator-${ALLOCATOR}.tar.gz
	${GITHUB_URI}/dlang-community/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	${GITHUB_URI}/economicmodeling/containers/tar.gz/${CONTAINERS} -> containers-${CONTAINERS}.tar.gz
	${GITHUB_URI}/dlang-community/dsymbol/tar.gz/${DSYMBOL} -> dsymbol-${DSYMBOL}.tar.gz
	${GITHUB_URI}/burner/inifiled/tar.gz/${INIFILED} -> inifiled-${INIFILED}.tar.gz
	${GITHUB_URI}/dlang-community/libdparse/tar.gz/${LIBDPARSE} -> libdparse-${LIBDPARSE}.tar.gz
	https://github.com/dlang-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="dev-lang/ldc2"
RDEPEND="${DEPEND}"

src_prepare() {
	# Default ebuild unpack function places archives side-by-side ...
	mv -T ../containers-${CONTAINERS}            containers                       || die
	mv -T ../dsymbol-${DSYMBOL}                  dsymbol                          || die
	mv -T ../inifiled-${INIFILED}                inifiled                         || die
	mv -T ../libdparse-${LIBDPARSE}              libdparse                        || die
	# Stop makefile from executing git to write an unused githash.txt
	touch githash githash.txt || die "Could not generate githash"
	eapply_user
}

src_compile() {
	emake ldc || die
}

src_install() {
	dobin bin/dscanner
	dodoc README.md
}
