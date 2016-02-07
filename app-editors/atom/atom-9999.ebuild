# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit git-r3 flag-o-matic python-any-r1 eutils

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io"
SRC_URI=""

EGIT_REPO_URI="git://github.com/atom/atom"

LICENSE="MIT"
SLOT="0"

if [[ ${PV} == *9999 ]];then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
fi

IUSE=""

DEPEND="
	${PYTHON_DEPS}
	|| ( net-libs/nodejs[npm] net-libs/iojs[npm] )
	media-fonts/inconsolata
	gnome-base/gconf
	gnome-base/libgnome-keyring
	x11-libs/libnotify
	=app-shells/electron-0.34.5
"

RDEPEND="${DEPEND}"

QA_PRESTRIPPED="/usr/share/atom/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux"

pkg_setup() {
	python-any-r1_pkg_setup

	npm config set python $PYTHON
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	# Skip atom-shell & atom-shell-chromedriver download
	sed -i -e "s/defaultTasks = \['download-atom-shell', 'download-atom-shell-chromedriver', /defaultTasks = [/g" \
		./build/Gruntfile.coffee \
		|| die "Failed to fix Gruntfile"

	epatch "${FILESDIR}/remove-minidump.patch"

	# Fix atom location guessing
	sed -i -e 's/ATOM_PATH="$USR_DIRECTORY\/share\/atom/ATOM_PATH="$USR_DIRECTORY\/../g' \
		./atom.sh \
		|| die "Fail fixing atom-shell directory"

	# Make bootstrap process more verbose
	sed -i -e 's@node script/bootstrap@node script/bootstrap --no-quiet@g' \
		./script/build \
		|| die "Fail fixing verbosity of script/build"
	sed -e "s/<%= description %>/$pkgdesc/" \
    	    -e "s|<%= appName %>|Atom|"\
            -e "s|<%= installDir %>/share/<%= appFileName %>|/usr/bin|"\
            -e "s|<%= iconPath %>|atom|"\
            resources/linux/atom.desktop.in > resources/linux/Atom.desktop

}

src_configure() {
	# always fails because of missing symbols and using incorrect headers for git-node
	./script/build --verbose --build-dir "${T}"

	cp /usr/bin/node apm/node_modules/atom-package-manager/bin/node
	sed -i s/--harmony_collections//g apm/node_modules/atom-package-manager/bin/apm

	cd apm/node_modules/atom-package-manager/node_modules
	npm rebuild --build-from-source
}

src_compile() {
	./script/build --verbose --build-dir "${T}" || die "Compile failed"

	# Setup python path to builtin npm
	echo "python = $PYTHON" >> "${T}/Atom/resources/app/apm/.apmrc"
}

src_install() {
	into /usr
	insinto /usr/share/applications
	newins resources/linux/Atom.desktop atom.desktop
	insinto /usr/share/licenses/"${PN}"
	doins LICENSE.md
	insinto /usr/share/${PN}/resources
	exeinto /usr/bin

	cd "${T}/Atom/resources"

	# Installs everything in Atom/resources/app
	doins -r .

	# Fixes permissions
	fperms +x /usr/share/${PN}/resources/app/atom.sh
	fperms +x /usr/share/${PN}/resources/app/apm/bin/apm
	rm -r  ${D}/usr/share/${PN}/resources/app/apm/bin/node
	dosym /usr/bin/node /usr/share/${PN}/resources/app/apm/bin/node
	fperms +x /usr/share/${PN}/resources/app/apm/node_modules/npm/bin/node-gyp-bin/node-gyp

	# Symlinking to /usr/bin
	dosym ../share/${PN}/resources/app/atom.sh /usr/bin/atom
	dosym ../share/${PN}/resources/app/apm/bin/apm /usr/bin/apm
}
