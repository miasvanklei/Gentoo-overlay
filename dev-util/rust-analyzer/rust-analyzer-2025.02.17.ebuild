
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4

EAPI=8

CRATES="
	addr2line@0.22.0
	adler@1.0.2
	always-assert@0.2.0
	anyhow@1.0.86
	arbitrary@1.3.2
	arrayvec@0.7.4
	autocfg@1.3.0
	backtrace@0.3.73
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.7.0
	borsh@1.5.1
	byteorder@1.5.0
	camino@1.1.7
	cargo-platform@0.1.8
	cargo_metadata@0.18.1
	cc@1.1.22
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cfg_aliases@0.2.1
	chalk-derive@0.99.0
	chalk-ir@0.99.0
	chalk-recursive@0.99.0
	chalk-solve@0.99.0
	countme@3.0.1
	cov-mark@2.0.0
	crc32fast@1.4.2
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	ctrlc@3.4.4
	dashmap@5.5.3
	deranged@0.3.11
	derive_arbitrary@1.3.2
	directories@5.0.1
	dirs-sys@0.4.1
	dirs@5.0.1
	dissimilar@1.0.9
	dot@0.1.4
	drop_bomb@0.1.5
	either@1.13.0
	ena@0.14.3
	equivalent@1.0.1
	expect-test@1.5.0
	filetime@0.2.24
	fixedbitset@0.4.2
	flate2@1.0.31
	form_urlencoded@1.2.1
	fsevent-sys@4.1.0
	fst@0.4.7
	getrandom@0.2.15
	gimli@0.29.0
	hashbrown@0.14.5
	heck@0.4.1
	hermit-abi@0.3.9
	home@0.5.9
	idna@0.5.0
	indexmap@2.3.0
	inotify-sys@0.1.5
	inotify@0.11.0
	itertools@0.12.1
	itoa@1.0.11
	jod-thread@0.1.2
	kqueue-sys@1.0.4
	kqueue@1.0.8
	la-arena@0.3.1
	lazy_static@1.5.0
	libc@0.2.169
	libloading@0.8.5
	libmimalloc-sys@0.1.39
	libredox@0.1.3
	line-index@0.1.2
	linked-hash-map@0.5.6
	lock_api@0.4.12
	log@0.4.22
	lsp-server@0.7.7
	lsp-types@0.95.0
	lz4_flex@0.11.3
	memchr@2.7.4
	memmap2@0.5.10
	memoffset@0.9.1
	mimalloc@0.1.43
	miniz_oxide@0.7.4
	mio@1.0.3
	miow@0.6.0
	nix@0.28.0
	nohash-hasher@0.2.0
	notify-types@2.0.0
	notify@8.0.0
	nu-ansi-term@0.50.1
	num-conv@0.1.0
	num_cpus@1.16.0
	num_threads@0.1.7
	object@0.33.0
	object@0.36.3
	once_cell@1.19.0
	oorandom@11.1.4
	option-ext@0.2.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	percent-encoding@2.3.1
	perf-event-open-sys@1.0.1
	perf-event@0.4.7
	petgraph@0.6.5
	pin-project-lite@0.2.14
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	proc-macro2@1.0.93
	process-wrap@8.0.2
	protobuf-support@3.7.1
	protobuf@3.7.1
	pulldown-cmark-to-cmark@10.0.4
	pulldown-cmark@0.9.6
	quote@1.0.36
	ra-ap-rustc_abi@0.94.0
	ra-ap-rustc_index@0.94.0
	ra-ap-rustc_index_macros@0.94.0
	ra-ap-rustc_lexer@0.94.0
	ra-ap-rustc_parse_format@0.94.0
	ra-ap-rustc_pattern_analysis@0.94.0
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.3
	redox_users@0.4.5
	rowan@0.15.15
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustc-hash@2.0.0
	rustc_apfloat@0.2.1+llvm-462a31f5a5ab
	ryu@1.0.18
	same-file@1.0.6
	scip@0.5.1
	scoped-tls@1.0.1
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.216
	serde_derive@1.0.216
	serde_json@1.0.124
	serde_repr@0.1.19
	serde_spanned@0.6.7
	sharded-slab@0.1.7
	shlex@1.3.0
	smallvec@1.13.2
	smol_str@0.3.2
	syn@2.0.87
	synstructure@0.13.1
	tenthash@1.0.0
	text-size@1.1.1
	thiserror-impl@1.0.63
	thiserror@1.0.63
	thread_local@1.1.8
	tikv-jemalloc-ctl@0.5.4
	tikv-jemalloc-sys@0.5.4+5.3.0-patched
	tikv-jemallocator@0.5.4
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.20
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing-tree@0.3.1
	tracing@0.1.40
	triomphe@0.1.14
	typed-arena@2.0.2
	ungrammar@1.16.1
	unicase@2.7.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-properties@0.1.1
	unicode-xid@0.2.4
	url@2.5.2
	valuable@0.1.0
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-util@0.1.9
	windows-core@0.56.0
	windows-implement@0.56.0
	windows-interface@0.56.0
	windows-result@0.1.2
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.56.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.18
	write-json@0.1.4
	xflags-macros@0.3.2
	xflags@0.3.2
	xshell-macros@0.2.7
	xshell@0.2.7
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zip@0.6.6
"

inherit cargo

MY_PV="${PV//./-}"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

DESCRIPTION="A language server for the Rust programming language"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://rust-analyzer.github.io"
SRC_URI="${CARGO_CRATE_URIS}
	https://github.com/rust-lang/rust-analyzer/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE=""
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions CC0-1.0 ISC MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-lang/rust"
RDEPEND="!dev-lang/rust[rust-analyzer]"

src_configure() {
	local myfeatures=(
		sysroot-abi
	)

	cargo_src_configure
}

src_compile() {
	export CFG_RELEASE=nightly
	export RUSTC_BOOTSTRAP=1
	cargo_src_compile -p proc-macro-srv-cli
	cargo_src_compile -p rust-analyzer
}

src_install() {
	pushd crates/rust-analyzer >/dev/null
	cargo_src_install
	popd >/dev/null

	pushd crates/proc-macro-srv-cli >/dev/null
	cargo_src_install
	popd >/dev/null
}
