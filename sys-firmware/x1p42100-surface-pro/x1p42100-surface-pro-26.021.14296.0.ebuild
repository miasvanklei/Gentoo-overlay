# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix udev

DESCRIPTION="firmware files for the surface pro 12-inch"
HOMEPAGE=""
SRC_URI="https://download.microsoft.com/download/3f42130f-64d6-4a85-8a18-ec1b70f5ef82/SurfacePro_12in_1st_Edition_Win11_26100_${PV}.msi -> ${PN}-${PV}.msi"

LICENSE=""
SLOT="0"
KEYWORDS="~arm64"
IUSE=""
RESTRICT="strip test"

BDEPEND="app-arch/msitools"

S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	msiextract "${DISTDIR}/${PN}-${PV}.msi" > /dev/null || die

	cd SurfaceUpdate || die
	edos2unix $(find surfaceprosnscfgcrd8380 -type 'f')

	eapply_user
}

src_install() {
	local firmwaredir="lib/firmware/qcom/x1p42100/Microsoft/sp12"
	local fastrpcdir="usr/share/qcom/x1p42100/Microsoft/sp12"

	cd SurfaceUpdate || die

	insinto /${firmwaredir}

	# ADSP
	doins proextadsp8380/qcadsp8380.mbn
	doins proextadsp8380/adsp_dtbs.elf

	# CDSP
	doins qcnspmcdmextcdsp8380/qccdsp8380.mbn
	doins qcnspmcdmextcdsp8380/cdsp_dtbs.elf

	# GPU
	doins qcdx8380/qcdxkmsuc8380.mbn
	doins qcdx8380/qcdxkmsucpurwa.mbn

	# Venus/Iris
	doins qcdx8380/qcav1e8380.mbn
	doins qcdx8380/qcvss8380_pa.mbn
	doins qcdx8380/qcvss8380.mbn

	# fastroc
	insinto /usr/share/qcom/conf.d
	doins ${FILESDIR}/sp12.yml

	# ssc
	udev_dorules ${FILESDIR}/81-libssc-surfacepro12.rules

	# sensordata
	insinto /${fastrpcdir}/vendor/etc/sensors/
	sed -i \
		-e "s|file=output=/persist|file=output=/${fastrpcdir}/persist|g" \
		-e "s|file=config=/vendor|file=config=/${fastrpcdir}/vendor|g" surfaceprosnscfgcrd8380/sns_reg_config || die
	doins surfaceprosnscfgcrd8380/sns_reg_config

	insinto /${fastrpcdir}/vendor/etc/sensors/config
	doins surfaceprosnscfgcrd8380/json.lst
	doins surfaceprosnscfgcrd8380/*.json

	keepdir /${fastrpcdir}/persist/sensors/registry/registry
}

pkg_postinst() {
        udev_reload
}

pkg_postrm() {
        udev_reload
}
