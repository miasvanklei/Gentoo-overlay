# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=true
PROTOBUF_PV="1.10.0"

inherit distutils-r1 pypi

DESCRIPTION="Python worker for Azure Functions"
HOMEPAGE="https://github.com/Azure/azure-functions-python-worker"
SRC_URI="
	https://github.com/Azure/azure-functions-python-worker/archive/refs/tags/4.35.0.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-python/grpcio-tools[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/azurefunctions-extensions-base[${PYTHON_USEDEP}]
	dev-python/azure-functions[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/grpcio[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/fix-install-sources.patch"
	"${FILESDIR}/support-all-python-versions.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# generate protos
	pushd tests >/dev/null
	python -c 'import test_setup; test_setup.gen_grpc()' || die
	popd >/dev/null
}


python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/lib/azure-functions-core-tools-4/workers/python
	doins python/prodV4/worker.config.json
}
