# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

PULSE_PN="${PN/-modules-xrdp/}"
PULSE_PV="${PV/.9999/}"
PULSE="${PULSE_PN}-${PULSE_PV}"

DESCRIPTION="xrdp sink / source pulseaudio modules"
HOMEPAGE="https://github.com/neutrinolabs/pulseaudio-module-xrdp.git"
SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${PULSE}.tar.xz"
EGIT_REPO_URI="https://github.com/neutrinolabs/pulseaudio-module-xrdp.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	=media-sound/pulseaudio-${PULSE_PV}*[-bluetooth]
"

RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	git-r3_fetch
	git-r3_checkout

	unpack "${PULSE}".tar.xz
}

src_prepare() {
	eapply "${FILESDIR}"/fix-build.patch

	sed -i -e 's/@@VERSION@@/${PULSE_PV}/g' config.h

	eapply_user
	eautoreconf
}

src_configure() {
	export PULSE_DIR=${WORKDIR}/${PULSE}
	econf
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
