# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4

EAPI=8

CRATES="
	Inflector@0.11.4
	addr2line@0.19.0
	adler@1.0.2
	aho-corasick@0.7.20
	aho-corasick@1.0.1
	ansi_term@0.12.1
	atty@0.2.14
	autocfg@1.1.0
	backtrace@0.3.67
	base64@0.12.3
	bitflags@1.3.2
	byteorder@1.4.3
	bytes@1.4.0
	cc@1.0.79
	cfg-if@1.0.0
	clap@2.34.0
	cpp@0.5.8
	cpp_build@0.5.8
	cpp_common@0.5.8
	cpp_macros@0.5.8
	crossterm@0.9.6
	crossterm_cursor@0.2.6
	crossterm_input@0.3.9
	crossterm_screen@0.2.5
	crossterm_style@0.3.3
	crossterm_terminal@0.2.6
	crossterm_utils@0.2.4
	crossterm_winapi@0.1.5
	dotenvy@0.15.7
	env_logger@0.8.4
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	futures@0.3.28
	fuzzy-matcher@0.3.7
	gimli@0.27.2
	hashbrown@0.12.3
	hermit-abi@0.1.19
	hermit-abi@0.2.6
	indexmap@1.9.3
	itoa@1.0.6
	lazy_static@1.4.0
	libc@0.2.142
	lock_api@0.4.9
	log@0.4.17
	memchr@2.5.0
	minimal-lexical@0.2.1
	miniz_oxide@0.6.2
	mio@0.8.6
	nom@7.1.3
	num-traits@0.2.15
	num_cpus@1.15.0
	num_enum@0.5.11
	num_enum_derive@0.5.11
	object@0.30.3
	once_cell@1.17.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	parse_int@0.5.0
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	proc-macro-crate@1.3.1
	proc-macro2@1.0.67
	quote@1.0.26
	redox_syscall@0.2.16
	regex-syntax@0.7.1
	regex@1.8.1
	rustc-demangle@0.1.23
	ryu@1.0.13
	schemafy@0.5.2
	schemafy_core@0.5.2
	schemafy_lib@0.5.2
	scopeguard@1.1.0
	serde@1.0.160
	serde_derive@1.0.160
	serde_json@1.0.96
	serde_repr@0.1.12
	signal-hook-registry@1.4.1
	slab@0.4.8
	smallvec@1.10.0
	socket2@0.4.9
	strsim@0.8.0
	superslice@1.0.0
	syn@1.0.109
	syn@2.0.15
	termios@0.3.3
	textwrap@0.11.0
	thread_local@1.1.7
	tokio-macros@2.1.0
	tokio-util@0.6.10
	tokio@1.28.0
	toml_datetime@0.6.1
	toml_edit@0.19.8
	unicode-ident@1.0.8
	unicode-width@0.1.10
	unicode-xid@0.2.4
	vec_map@0.8.2
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	winnow@0.4.1
	winreg@0.6.2
"

inherit cargo

DESCRIPTION="A native debugger extension for VSCode based on LLDB"
HOMEPAGE="https://github.com/vadimcn/codelldb"
SRC_URI="https://github.com/vadimcn/codelldb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

S="${WORKDIR}/${P}/adapter"

LICENSE=""
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 MIT Unicode-DFS-2016"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}/fix-compile-on-musl.patch"
)

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare()
{
	default
	cargo update -p proc-macro2
}
