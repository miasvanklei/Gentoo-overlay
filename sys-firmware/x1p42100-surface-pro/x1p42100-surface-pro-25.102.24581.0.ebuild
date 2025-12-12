# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

src_install() {
	msiextract "${DISTDIR}/${PN}-${PV}.msi" > /dev/null || die

	cd SurfaceUpdate || die

	insinto /lib/firmware/qcom/x1p42100/Microsoft/SurfacePro

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
}
