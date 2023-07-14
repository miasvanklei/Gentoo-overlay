# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Shairport Sync is an AirPlay audio player"
HOMEPAGE="https://github.com/mikebrady/shairport-sync"
SRC_URI="https://github.com/mikebrady/shairport-sync/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="airplay2 +alsa convolution pulseaudio jack mbedtls +openssl pipewire pulseaudio soundio soxr"
REQUIRED_USE="
	|| ( alsa pulseaudio jack )
	^^ ( openssl mbedtls )"

RDEPEND="
	acct-user/shairport-sync
	acct-group/shairport-sync
	dev-libs/libconfig
	dev-libs/popt
	net-dns/avahi
	airplay2? (
		app-pda/libplist
		dev-libs/libgcrypt
		dev-libs/libsodium
		dev-util/xxd
		media-video/ffmpeg
		sys-apps/util-linux
		sys-apps/nqptp
	)
	alsa? ( media-libs/alsa-lib )
	convolution? ( media-libs/libsndfile )
	jack? ( virtual/jack )
	mbedtls? ( net-libs/mbedtls )
	openssl? ( dev-libs/openssl )
	pipewire? ( media-video/pipewire )
	pulseaudio? ( media-sound/pulseaudio )
	soundio? ( media-libs/libsoundio )
	soxr? ( media-libs/soxr )
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/remove_useradd.patch"
)

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	local myconf
	if use openssl ;then
		myconf="$myconf --with-ssl=openssl"
	elif use mbedtls ;then
		myconf="$myconf --with-ssl=mbedtls"
	fi

	econf \
		--with-avahi \
		--with-configfiles \
		--with-metadata \
		--with-pipe \
		--with-stdout \
		--with-systemd \
		$(use_with airplay2 airplay-2) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with pulseaudio pa) \
		$(use_with pipewire pw) \
		$(use_with soundio) \
		$(use_with soxr) \
		$(use_with convolution) \
		$myconf
}
