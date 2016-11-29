# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A cross-platform C# IDE by JetBrains"
HOMEPAGE="https://www.jetbrains.com/rider"
SRC_URI="http://download.jetbrains.com/resharper/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips ~sparc ~x86"

DEPEND="dev-lang/mono
	dev-java/icedtea
	dev-dotnet/nuget"

src_install()
{
	cd "${S}"
        cp "${FILESDIR}/${PN}.desktop" ./
	install -dm 755 \
	"${D}/opt/${PN}" \
	"${D}/usr/bin/" \
	"${D}/usr/share/applications/"

	cp -R --no-preserve=ownership bin "${D}/opt/${PN}"
	cp -R --no-preserve=ownership lib "${D}/opt/${PN}"
	cp -R --no-preserve=ownership plugins "${D}/opt/${PN}"
	sed -i "s/Version=/Version=${PV}/g" "${PN}.desktop"
	rm "${D}/opt/riderRS/bin/libyjpagent-linux64.so"
	sed -i 's#$root/$platform-x64/mono#/usr#g' ${D}/opt/riderRS/lib/ReSharperHost/runtime.sh

	install -m644 "${PN}.desktop" "${D}/usr/share/applications/"

	ln -s "/opt/${PN}/bin/rider.sh" "${D}/usr/bin/rider-eap"
}
