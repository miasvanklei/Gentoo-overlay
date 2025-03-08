# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="An implementation of the Debug Adapter Protocol for Python"
HOMEPAGE="https://github.com/microsoft/debugpy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

python_prepare_all() {
	distutils-r1_python_prepare_all

	cd src/debugpy/_vendored/pydevd/pydevd_attach_to_process || die

	rm -r windows winappdbg || die
	cd linux_and_mac || die
	rm compile_mac.sh || die
}

python_compile() {
	pushd src/debugpy/_vendored/pydevd/pydevd_attach_to_process/linux_and_mac || die
	$(tc-getBUILD_CXX) ${CXXFLAGS} ${CPPFLAGS} \
		-o "../attach_linux_${ARCH}.so" \
		${LDFLAGS} -nostartfiles attach.cpp -ldl || die
	popd || die

	distutils-r1_python_compile

	rm -r "${BUILD_DIR}"/install/$(python_get_sitedir)/_pydevd* || die
}
