# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=true

inherit distutils-r1 pypi

DESCRIPTION="Python worker for Azure Functions"
HOMEPAGE="https://github.com/Azure/azure-functions-python-worker"
SRC_URI="
	https://github.com/Azure/azure-functions-python-worker/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-python/grpcio-tools[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/azure-functions-runtime[${PYTHON_USEDEP}]
	dev-python/azure-functions-runtime-v1[${PYTHON_USEDEP}]
	dev-python/azure-functions-extensions-base[${PYTHON_USEDEP}]
	dev-python/azure-functions[${PYTHON_USEDEP}]
	dev-python/grpcio[${PYTHON_USEDEP}]
	dev-python/grpcio-tools[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/uvloop[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/remove-invoke.patch"
	"${FILESDIR}/fix-worker_py-path.patch"
)

S="${WORKDIR}/${P}/workers"

python_prepare_all() {
	dos2unix tests/test_setup.py
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	# generate protos
	pushd tests >/dev/null
	"${EPYTHON}" -c 'import test_setup; test_setup.gen_grpc()' || die
	popd >/dev/null
}

python_install() {
	local pyversion="${MULTIBUILD_VARIANT/python/}"
	pyversion="${pyversion/_/.}"

	# install config
	insinto /usr/lib/azure-functions-core-tools-4/workers/python
	doins python/prodV4/worker.config.json

	# install worker
	local worker=$(if [[ ${pyversion} < "3.13" ]]; then echo "azure_functions_worker"; else echo "proxy_worker"; fi)

	python_moduleinto /usr/lib/azure-functions-core-tools-4/workers/python/${pyversion}/
	python_domodule python/proxyV4/*

	python_moduleinto /usr/lib/azure-functions-core-tools-4/workers/python/${pyversion}/
	python_domodule ${worker}
}
