# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"
EGIT_BRANCH="release/9.x"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!sys-devel/llvm:0"

S="${WORKDIR}"/llvm

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' "${WORKDIR}" '' llvm/utils/vim
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/
	# some users may find it useful
	newdoc utils/vim/README README.vim
	dodoc utils/vim/vimrc
}
