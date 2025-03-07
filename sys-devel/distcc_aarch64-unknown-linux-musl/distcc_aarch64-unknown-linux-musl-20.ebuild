# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit distcc

DESCRIPTION="Symlinks to a Clang crosscompiler"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64"
