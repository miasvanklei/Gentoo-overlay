# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tarball generated using "gh workflow -R ${repo}/gentoo-deps run generator.yml -f REPO=vadimcn/codelldb -f TAG=v${PV} -f P=codelldb-${PV} -f LANG=rust -f WORKDIR=adapter/codelldb"

declare -A GIT_CRATES=(
	[weaklink]='https://github.com/vadimcn/weaklink;e11a77c73534b18c354ee98765dd20354ec45258;weaklink-%commit%/weaklink'
	[weaklink_build]='https://github.com/vadimcn/weaklink;e11a77c73534b18c354ee98765dd20354ec45258;weaklink-%commit%/weaklink_build'
)

inherit cargo

DESCRIPTION="A native debugger extension for VSCode based on LLDB"
HOMEPAGE="https://github.com/vadimcn/codelldb"
SRC_URI="https://github.com/vadimcn/codelldb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/miasvanklei/gentoo-deps/releases/download/${P}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}"

LICENSE=""
# Dependent crate licenses
LICENSE+="
	BSD-2 MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

RDEPEND="llvm-core/lldb:="

PATCHES=(
	"${FILESDIR}/fix-compile-on-musl.patch"
	"${FILESDIR}/fix-libcxx-20.patch"
)

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	mkdir .cargo
	cat <<- _EOF_ > "${S}"/.cargo/config.toml
		[env]
		LLDB_INCLUDE = "/usr/include/lldb"
		LLDB_DYLIB = "/usr/lib/liblldb.so"
	_EOF_

	default
}

src_compile() {
        cargo_src_compile -p codelldb
}

src_install() {
        pushd adapter/codelldb >/dev/null
        cargo_src_install
        popd >/dev/null

	insinto /usr/lib/codelldb/scripts
	for file in adapter/scripts/*.py; do
		doins $file
	done

	insinto /usr/lib/codelldb/scripts/codelldb
	for file in adapter/scripts/codelldb/*.py; do
		doins $file
	done

	mv ${D}/usr/bin/codelldb ${D}/usr/lib/codelldb
}
