# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CARGO_SNAPSHOT_DATE="2016-03-21"

inherit cargo bash-completion-r1

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"
SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://alpine.geeknet.cz/distfiles/cargo-0.11.0-nightly-x86_64-alpine-linux-musl.tar.gz ->
	cargo-snapshot-amd64-${CARGO_SNAPSHOT_DATE}.tar.gz"

RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc"

COMMON_DEPEND="sys-libs/zlib
	dev-libs/openssl:0=
	net-libs/libssh2
	net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/rust-1.9.0:stable
	dev-util/cmake
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/findutils
	sys-apps/sed"

src_configure() {
	# Cargo only supports these GNU triples:
	# - Linux: <arch>-unknown-linux-gnu
	# - MacOS: <arch>-apple-darwin
	# - Windows: <arch>-pc-windows-gnu
	# where <arch> could be 'x86_64' (amd64) or 'i686' (x86)
	use amd64 && use !elibc_musl && CTARGET="x86_64-unknown-linux-gnu"
	use amd64 && use elibc_musl && CTARGET="x86_64-unknown-linux-musl"

	# NOTE: 'disable-nightly' is used by crates (such as 'matches') to entirely
	# skip their internal libraries that make use of unstable rustc features.
	# Don't use 'enable-nightly' with a stable release of rustc as DEPEND,
	# otherwise you could get compilation issues.
	# see: github.com/gentoo/gentoo-rust/issues/13
	local myeconfargs=(
		--host=${CTARGET}
		--build=${CTARGET}
		--target=${CTARGET}
		--enable-optimize
		--disable-nightly
		--disable-verify-install
		--disable-debug
		--disable-cross-tests
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Building sources
	export CARGO_HOME="${ECARGO_HOME}"
	emake VERBOSE=1 PKG_CONFIG_PATH=""

	# Building HTML documentation
	use doc && emake doc
}

src_install() {
	emake prepare-image-${CTARGET} IMGDIR_${CTARGET}="${ED}/usr"

	# Install HTML documentation
	use doc && HTML_DOCS=("target/doc")
	einstalldocs

	dobashcomp "${ED}"/usr/etc/bash_completion.d/cargo
	rm -rf "${ED}"/usr/etc || die
}

src_test() {
	# Running unit tests
	# NOTE: by default 'make test' uses the copy of cargo (v0.0.1-pre-nighyly)
	# from the installer snapshot instead of the version just built, so the
	# ebuild needs to override the value of CFG_LOCAL_CARGO to avoid false
	# positives from unit tests.
	emake test \
		CFG_ENABLE_OPTIMIZE=1 \
		VERBOSE=1 \
		CFG_LOCAL_CARGO="${WORKDIR}"/${P}/target/${CTARGET}/release/cargo
}
