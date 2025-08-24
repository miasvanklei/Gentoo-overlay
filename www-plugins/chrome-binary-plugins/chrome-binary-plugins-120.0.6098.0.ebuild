# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Binary plugins from Google Chrome for use in Firefox"
HOMEPAGE="https://www.google.com/chrome/"

SRC_URI="https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${PV} -> chrome-os-${PV}.squashfs"
S="${WORKDIR}"

LICENSE="google-chrome"
KEYWORDS="-* ~arm64"
RESTRICT="bindist mirror strip"
SLOT="0"

BDEPEND="
	sys-fs/squashfs-tools[zstd]
"

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	elibc_musl? ( sys-libs/widevine-compat )
"

QA_PREBUILT="*"

src_unpack() {
	einfo "Unpacking WidevineCdm"
	unsquashfs -q "${DISTDIR}/chrome-os-${PV}.squashfs" -d "${WORKDIR}" 'WidevineCdm/*' >/dev/null
}

src_install() {
	local basedir="squashfs-root/WidevineCdm"
	insinto "/var/lib/widevine"
	doins ${basedir}/_platform_specific/cros_arm64/libwidevinecdm.so
	doins ${basedir}/manifest.json

	insinto "/var/lib/widevine/gmp-widevinecdm/system-installed"
	dosym "../../manifest.json" /var/lib/widevine/gmp-widevinecdm/system-installed/manifest.json
	dosym "../../libwidevinecdm.so" /var/lib/widevine/gmp-widevinecdm/system-installed/libwidevinecdm.so

	insinto "/usr/lib/environment.d"
	doins "${FILESDIR}/gmpwidevine.conf"

	insinto "/usr/lib/firefox/defaults/pref"
	doins "${FILESDIR}/gmpwidevine.js"
}
