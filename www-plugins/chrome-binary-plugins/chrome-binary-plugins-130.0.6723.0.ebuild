# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Binary plugins from Google Chrome for use in Firefox"
HOMEPAGE="https://www.google.com/chrome/"

SRC_URI="
	arm64? (
		https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${PV} -> chrome-os-arm64-${PV}.squashfs
		https://raw.githubusercontent.com/AsahiLinux/widevine-installer/8fa12dd2d81c4b5d2a713e169cac70898512322e/widevine_fixup.py
	)
	amd64? (
		https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-amd64-squash-zstd-${PV} -> chrome-os-amd64-${PV}.squashfs
	)
"
S="${WORKDIR}"

LICENSE="google-chrome"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="bindist mirror strip"
SLOT="0"

BDEPEND="
	sys-fs/squashfs-tools[zstd]
	dev-lang/python
	elibc_musl? (
		dev-util/patchelf
	)
"

RDEPEND="
	elibc_musl? (
		sys-libs/widevine-compat
	)
"

QA_PREBUILT="*"

get_soname() {
        if use arm64; then
                echo "aarch64.so.1"
        elif use amd64; then
                echo "x86-64.so.2"
        fi
}

src_unpack() {
	einfo "Unpacking WidevineCdm"

	if use arm64; then
		unsquashfs -q "${DISTDIR}/chrome-os-arm64-${PV}.squashfs" -d "${WORKDIR}" 'WidevineCdm/*' >/dev/null || die
	elif use amd64; then
		unsquashfs -q "${DISTDIR}/chrome-os-amd64-${PV}.squashfs" -d "${WORKDIR}" 'WidevineCdm/*' >/dev/null || die
	fi
}

src_compile() {
	local basedir="squashfs-root/WidevineCdm"

	if use arm64; then
		# fix missing a missing symbol
		python "${DISTDIR}"/widevine_fixup.py ${basedir}/_platform_specific/cros_arm64/libwidevinecdm.so "${S}"/libwidevinecdm.so || die
	elif use amd64; then
		cp ${basedir}/_platform_specific/cros_x64/libwidevinecdm.so "${S}"/libwidevinecdm.so || die
	fi

	# Fix some websites checking the platform_name
	sed -i -e 's/ChromeOS/Linux\x0\x0\x0/g' "${S}"/libwidevinecdm.so || die

	if use elibc_musl; then
		# glibc symbols which do not exist on musl
		cat <<- _EOF_ > "${S}"/remap-symbols
			__libc_calloc calloc
			__libc_free free
			__libc_malloc malloc
			__libc_memalign memalign
			__libc_realloc realloc
			__mbrlen mbrlen
			__strdup strdup
			__open64_2 open
			fcntl64 fcntl
			__longjmp_chk longjmp
		_EOF_

		patchelf --rename-dynamic-symbols "${S}/remap-symbols" "${S}"/libwidevinecdm.so || die
		patchelf --replace-needed "ld-linux-$(get_soname)" "libwidevine_compat.so.1" "${S}"/libwidevinecdm.so || die

		if use arm64; then
			patchelf --remove-needed libnspr4.so "${S}"/libwidevinecdm.so || die
		fi
	fi
}

src_install() {
	local basedir="squashfs-root/WidevineCdm"
	local widevinedir="/var/lib/widevine"

	insinto "${widevinedir}"
	doins "${S}"/libwidevinecdm.so
	doins "${basedir}"/manifest.json

	insinto "${widevinedir}/gmp-widevinecdm/system-installed"
	dosym "../../manifest.json" "${widevinedir}/gmp-widevinecdm/system-installed/manifest.json"
	dosym "../../libwidevinecdm.so" "${widevinedir}/gmp-widevinecdm/system-installed/libwidevinecdm.so"

	insinto "/usr/lib/environment.d"
	doins "${FILESDIR}/gmpwidevine.conf"

	insinto "/usr/lib/firefox/defaults/pref"
	doins "${FILESDIR}/gmpwidevine.js"
}
