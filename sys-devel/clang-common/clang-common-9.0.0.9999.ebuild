# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 git-r3

DESCRIPTION="Common files shared between multiple slots of clang"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"
EGIT_BRANCH="release/9.x"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

PDEPEND="sys-devel/clang:*"

S="${WORKDIR}"/clang

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' "${WORKDIR}" '' clang/utils/bash-autocomplete.sh
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	newbashcomp utils/bash-autocomplete.sh clang
}
