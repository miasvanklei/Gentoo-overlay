# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95.0"

inherit cargo

MY_PV="${PV//./-}"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

DESCRIPTION="A language server for the Rust programming language"
HOMEPAGE="https://rust-analyzer.github.io"
SRC_URI="https://github.com/rust-lang/rust-analyzer/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/miasvanklei/gentoo-deps/releases/download/${P}/${P}-crates.tar.xz"

S="${WORKDIR}/rust-analyzer-${MY_PV}"

LICENSE=""
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions CC0-1.0 ISC MIT MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-lang/rust"
RDEPEND="!dev-lang/rust[rust-analyzer]"

PATCHES=(
	"${FILESDIR}/revert-use-into-string.patch"
)

src_compile() {
	export CFG_RELEASE=nightly
	export RUSTC_BOOTSTRAP=1

	cargo_src_compile -p ${PN} --features sysroot-abi
}

src_install() {
	pushd crates/proc-macro-srv-cli >/dev/null
	cargo_src_install --features sysroot-abi
	popd >/dev/null
}
