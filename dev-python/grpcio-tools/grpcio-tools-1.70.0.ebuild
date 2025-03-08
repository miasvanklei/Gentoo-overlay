# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{9..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 multiprocessing prefix pypi

DESCRIPTION="Protobuf code generator for gRPC"
HOMEPAGE="https://grpc.io"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

RDEPEND="
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
	>=dev-python/protobuf-5.26.1[${PYTHON_USEDEP}]
	<dev-python/protobuf-6[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-python/cython[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py

	# use system protobuf
	sed -r -i \
		-e '/^CC_FILES=\[/,/\]/{/^CC_FILES=\[/n;/\]/!d;}' \
		-e '/^CC_INCLUDES=\[/,/\]/{/^CC_INCLUDES=\[/n;/\]/!d;}' \
		-e "s@^(PROTO_INCLUDE=')[^']+'@\1/usr/include'@" \
		-e '/^PROTOBUF_SUBMODULE_VERSION=/d' \
		protoc_lib_deps.py

	# fix the include path
	ln -s ../../../.. grpc_root
}

src_configure() {
        export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
        # system abseil-cpp crashes with USE=-debug, sigh
        # https://bugs.gentoo.org/942021
        #export GRPC_PYTHON_BUILD_SYSTEM_ABSL=1
        export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
        export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
        # re2 needs to be built against the same abseil-cpp version
        #export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
        export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
        export GRPC_PYTHON_BUILD_WITH_CYTHON=1

        # copied from setup.py, except for removed -std= that does not apply
        # to C code and causes warnings
        export GRPC_PYTHON_CFLAGS="-fvisibility=hidden -fno-wrapv"

	# fix underlinking
	export GRPC_PYTHON_LDFLAGS="-lprotoc"
        # silence a lot of harmless noise from bad quality code
        append-cxxflags -Wno-attributes
}
