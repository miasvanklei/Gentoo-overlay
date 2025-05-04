# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ClangD file for opencl headers"
HOMEPAGE="https://llvm.org/"

S="${WORKDIR}"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE=""

src_install() {
	insinto /usr/lib/clang/${SLOT}/include/
	newins - .clangd <<-EOF
		If:
		    PathMatch: [opencl-c.h, opencl-c-base.h]
		CompileFlags:
		    Add: [-xcl]
	EOF
}
