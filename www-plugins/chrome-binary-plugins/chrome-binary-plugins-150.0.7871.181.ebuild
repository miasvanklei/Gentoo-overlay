# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Binary plugins from Google Chrome for use in Firefox"
HOMEPAGE="https://www.google.com/chrome/"

case ${PV} in
        *_alpha*)
                SLOT="unstable"
                CHROMEDIR="opt/google/chrome-${SLOT}"
                MY_PV=${PV%_alpha}-1
                ;;
        *_beta*)
                SLOT="beta"
                CHROMEDIR="opt/google/chrome-${SLOT}"
                MY_PV=${PV%_beta}-1
                ;;
        *)
                SLOT="stable"
                CHROMEDIR="opt/google/chrome"
                MY_PV=${PV}-1
                ;;
esac

MY_PN="google-chrome-${SLOT}"
MY_P="${MY_PN}_${MY_PV}"
SRC_URI="
	amd64? ( https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb )
	arm64? ( https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_arm64.deb )
"
S="${WORKDIR}/${CHROMEDIR}/WidevineCdm"

LICENSE="google-chrome"
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist mirror strip"
SLOT="0"

BDEPEND="
	elibc_musl? (
		dev-util/patchelf
		dev-lang/python
	)
"

RDEPEND="
	elibc_musl? (
		sys-libs/widevine-compat
	)
	!media-libs/openh264[plugin]
"

for x in 0 beta stable unstable; do
	if [[ ${SLOT} != ${x} ]]; then
		RDEPEND+=" !${CATEGORY}/${PN}:${x}"
	fi
done

QA_PREBUILT="*"

get_soname() {
	if use arm64; then
		echo "aarch64.so.1"
	elif use amd64; then
		echo "x86-64.so.2"
	fi
}

get_widevine_dir() {
        if use arm64; then
		echo "_platform_specific/linux_arm64"
        elif use amd64; then
                echo "_platform_specific/linux_x64"
        fi
}

src_compile() {
	if use elibc_musl; then
		local widevine_dir="$(get_widevine_dir)"

		# glibc symbols which do not exist on musl
		cat <<- _EOF_ > "${S}"/remap-symbols
			__mbrlen mbrlen
		_EOF_

		patchelf --rename-dynamic-symbols "${S}/remap-symbols" "${widevine_dir}"/libwidevinecdm.so || die
		patchelf --replace-needed "ld-linux-$(get_soname)" "libwidevine_compat.so.1" "${widevine_dir}"/libwidevinecdm.so || die

		if use arm64; then
			python "${FILESDIR}"/replace-ifuncs-with-direct-fallback.py "${widevine_dir}"/libwidevinecdm.so "${widevine_dir}"/libwidevinecdm_patched.so || die
			mv "${widevine_dir}"/libwidevinecdm_patched.so "${widevine_dir}"/libwidevinecdm.so || die
		fi
	fi
}

src_install() {
	local widevine_installdir="/var/lib/widevine"

	insinto "${widevine_installdir}"
	doins "$(get_widevine_dir)/libwidevinecdm.so"
	doins manifest.json

	insinto "${widevine_installdir}/gmp-widevinecdm/system-installed"
	dosym "../../manifest.json" "${widevine_installdir}/gmp-widevinecdm/system-installed/manifest.json"
	dosym "../../libwidevinecdm.so" "${widevine_installdir}/gmp-widevinecdm/system-installed/libwidevinecdm.so"

	doenvd "${FILESDIR}/99-gmpwidevine.conf"

	insinto "/usr/lib/firefox/defaults/pref"
	doins "${FILESDIR}/gmpwidevine.js"
}
