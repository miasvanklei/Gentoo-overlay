# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=""
LICENSE="public-domain"

SLOT=0
KEYWORDS="~arm64"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/ath11k/WCN6855/hw2.0/board-2.bin?h=${PV} -> qca-ath11k-board-2-${PV}.bin
	https://raw.githubusercontent.com/qca/qca-swiss-army-knife/refs/heads/master/tools/scripts/ath11k/ath11k-bdencoder"

BDEPEND="
	sys-kernel/linux-firmware
"

S="${WORKDIR}"

src_unpack() {
	default

	cp "${DISTDIR}"/ath11k-bdencoder "${S}"
	cp "${DISTDIR}"/qca-ath11k-board-2-${PV}.bin "${S}"
}

src_prepare() {
	chmod +x "${S}"/ath11k-bdencoder

	default
}

src_compile() {
	einfo "Extracting board file"
	"${S}"/ath11k-bdencoder -e qca-ath11k-board-2-${PV}.bin >/dev/null

	eapply "${FILESDIR}"/add-tw220-board-file.patch

	einfo "Recreating board file"
	"${S}"/ath11k-bdencoder -c board-2.json >/dev/null
}

src_install() {
	mkdir -p "${D}"/lib/firmware/qcom/sc8280xp/Ntmer/tw220
	cd "${D}"/lib/firmware/qcom/sc8280xp/Ntmer/tw220
	for i in /lib/firmware/qcom/sc8280xp/LENOVO/21BX/*; do
		filename=$(basename $i)
		ln -s ../../LENOVO/21BX/$filename $filename
	done
	ln -s audioreach-tplg.bin SC8280XP-NTMER-TW220-tplg.bin

	dodir /lib/firmware/ath11k/WCN6855/hw2.0
	insinto /lib/firmware/ath11k/WCN6855/hw2.0
	doins "${S}"/board-2.bin

	mkdir -p "${D}"/lib/firmware/ath11k/WCN6855/hw2.1
	cd "${D}"/lib/firmware/ath11k/WCN6855/hw2.1
	ln -s ../hw2.0/board-2.bin board-2.bin
}
