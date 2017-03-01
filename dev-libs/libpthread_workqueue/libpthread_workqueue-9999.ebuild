# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="libpthread_workqueue is a portable implementation of the pthread_workqueue API first introduced in Mac OS X."
HOMEPAGE="http://sourceforge.net/projects/libpwq/"
EGIT_REPO_URI="https://github.com/mheily/libpwq.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
