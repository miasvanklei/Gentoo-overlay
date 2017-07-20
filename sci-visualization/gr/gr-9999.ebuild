# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 python-single-r1

DESCRIPTION="GR framework: a graphics library for visualisation applications"
HOMEPAGE="https://github.com/jheinen/gr"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jheinen/gr"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+julia python static-libs"
REQUIRED_USE="
	python?  ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=""
DEPEND="
	media-libs/qhull
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
	julia? ( dev-lang/julia )"

PATCHES=(
	"${FILESDIR}"/system-libs.patch
)

pkg_setup() {
        use python && python-single-r1_pkg_setup
}

src_compile() {
	emake GRDIR="${D}"/usr PYTHONDIR=/usr/lib/python3/site-packages
}

src_install() {
	emake install GRDIR="${D}"/usr PYTHONBIN="/usr/bin/python2"
	rm "${D}"/usr/bin/anaconda || die
	mkdir "${D}"/usr/lib/gr || die
	mv "${D}"/usr/lib/*.so "${D}"/usr/lib/gr || die
	mv "${D}"/usr/lib/julia "${D}"/usr/lib/gr || die

	if use python; then
		mv "${D}"/usr/lib/python $(python_get_sitedir) || die
		ln -s /usr/lib/gr/*.so $(python_get_sitedir) || die
	else
		rm -r "${D}"/usr/lib/python || die
	fi

	if use julia; then
		mkdir -p "${D}"/usr/share/julia/site/v0.6 || die
		ln -s /usr/lib/gr/julia/*.jl "${D}"/usr/share/julia/site/v0.6/ || die
		mkdir -p "${D}"/usr/share/julia/site/deps/gr/lib || die
		ln -s /usr/lib/gr/*.so "${D}"/usr/share/julia/site/deps/gr/lib/ || die
	fi

	if use !static-libs; then
		rm -r "${D}"/usr/lib/*.a
	fi

	mkdir "${D}"/usr/lib/julia/fonts
	mv "${D}"/usr/fonts "${D}"/usr/lib/julia/fonts/
	ln -s /usr/lib/julia/fonts "${D}"/usr/share/julia/site/deps/gr/
}
