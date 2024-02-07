# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit git-r3 distutils-r1

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI=""
EGIT_REPO_URI="https://github.com/containers/podman-compose.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""
RESTRICT=""

RDEPEND=">=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

DOCS=( README.md )
