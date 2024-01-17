# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="LDDB's machine interface driver"
HOMEPAGE="https://llvm.org/"
EGIT_REPO_URI="https://github.com/lldb-tools/lldb-mi.git"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}
RESTRICT="test"

RDEPEND="dev-util/lldb:=
	sys-libs/zlib
        sys-devel/llvm:="
DEPEND="${RDEPEND}"
