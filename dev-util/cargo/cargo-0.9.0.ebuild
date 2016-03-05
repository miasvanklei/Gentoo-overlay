# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit bash-completion-r1 autotools-utils

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"

CARGO_SNAPSHOT_DATE="2015-11-02"
RUST_INSTALLER_COMMIT="c37d3747da75c280237dc2d6b925078e69555499"

SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rust-lang/rust-installer/archive/${RUST_INSTALLER_COMMIT}.tar.gz -> rust-installer-${RUST_INSTALLER_COMMIT}.tar.gz
	x86?   (
		https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${CARGO_SNAPSHOT_DATE}/cargo-nightly-i686-unknown-linux-gnu.tar.gz ->
		cargo-nightly-i686-unknown-linux-gnu-${CARGO_SNAPSHOT_DATE}.tar.gz
	)
	amd64? (
		https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/${CARGO_SNAPSHOT_DATE}/cargo-nightly-x86_64-unknown-linux-gnu.tar.gz ->
		cargo-nightly-x86_64-unknown-linux-gnu-${CARGO_SNAPSHOT_DATE}.tar.gz
	)"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc test"

COMMON_DEPEND="sys-libs/zlib
	dev-libs/openssl:*
	net-libs/libssh2
	net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	dev-lang/rust
	dev-util/cmake"

PATCHES=(
#	"${FILESDIR}"/${P}-local-deps.patch
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/stack-size.patch
)

src_unpack() {
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				ebegin "Unpacking ${archive}"
				tar -xf "${DISTDIR}"/${archive} || die
				eend $?
				;;
			*)
				unpack ${archive}
				;;
		esac
	done

	mv cargo-nightly-*-unknown-linux-gnu "cargo-snapshot" || die
	mv "rust-installer-${RUST_INSTALLER_COMMIT}"/* "${P}"/src/rust-installer || die
}

src_prepare() {
	pushd "${WORKDIR}" &>/dev/null
	autotools-utils_src_prepare
	popd &>/dev/null

	# FIX: doc path
	sed -i \
		-e "s:/share/doc/cargo:/share/doc/${PF}:" \
		Makefile.in || die
}

src_configure() {
	# Defines the level of verbosity.
	ECARGO_VERBOSE=""
	[[ -z ${PORTAGE_VERBOSE} ]] || ECARGO_VERBOSE=1

	# Cargo only supports these GNU triples:
	# - Linux: <arch>-unknown-linux-gnu
	# - MacOS: <arch>-apple-darwin
	# - Windows: <arch>-pc-windows-gnu
	# where <arch> could be 'x86_64' (amd64) or 'i686' (x86)
	CTARGET="-unknown-linux-gnu"
	use amd64 && CTARGET="x86_64${CTARGET}"
	use x86 && CTARGET="i686${CTARGET}"

	# NOTE: 'disable-nightly' is used by crates (such as 'matches') to entirely
	# skip their internal libraries that make use of unstable rustc features.
	# Don't use 'enable-nightly' with a stable release of rustc as DEPEND,
	# otherwise you could get compilation issues.
	# see: github.com/gentoo/gentoo-rust/issues/13
	local myeconfargs=(
		--build=${CTARGET}
		--host=${CTARGET}
		--target=${CTARGET}
		--enable-optimize
		--disable-nightly
		--disable-verify-install
		--disable-debug
		--disable-cross-tests
		--local-cargo=/usr/bin/cargo
	)
	autotools-utils_src_configure
}

src_compile() {
	# Building sources
	autotools-utils_src_compile VERBOSE=${ECARGO_VERBOSE} PKG_CONFIG_PATH=""

	# Building HTML documentation
	use doc && emake doc
}

src_install() {
	autotools-utils_src_install VERBOSE=${ECARGO_VERBOSE} CFG_DISABLE_LDCONFIG="true"

	# Install HTML documentation
	use doc && dohtml -r target/doc/*

	dobashcomp "${ED}"/usr/etc/bash_completion.d/cargo
	rm -r "${ED}"/usr/etc || die
	rm -r "${ED}"/usr/lib/rustlib || die
}

src_test() {
	if has sandbox $FEATURES && has network-sandbox $FEATURES; then
		eerror "Some tests require sandbox, and network-sandbox to be disabled in FEATURES."
	fi

	# Running unit tests
	# NOTE: by default 'make test' uses the copy of cargo (v0.0.1-pre-nighyly)
	# from the installer snapshot instead of the version just built, so the
	# ebuild needs to override the value of CFG_LOCAL_CARGO to avoid false
	# positives from unit tests.
	autotools-utils_src_test \
		CFG_ENABLE_OPTIMIZE=1 \
		VERBOSE=${ECARGO_VERBOSE} \
		CFG_LOCAL_CARGO="${WORKDIR}"/${P}/target/${CTARGET}/release/cargo
}
