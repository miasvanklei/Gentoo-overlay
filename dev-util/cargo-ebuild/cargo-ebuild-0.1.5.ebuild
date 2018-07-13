# Copyright 2017-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.1.5

EAPI=6

CRATES="
advapi32-sys-0.2.0
aho-corasick-0.6.3
atty-0.2.3
backtrace-0.3.3
backtrace-sys-0.1.16
bitflags-0.7.0
bitflags-0.8.2
cargo-0.21.1
cargo-ebuild-0.1.5
cc-1.0.3
cfg-if-0.1.0
cmake-0.1.22
crates-io-0.10.0
crossbeam-0.2.10
curl-0.4.6
curl-sys-0.3.10
dbghelp-sys-0.2.0
docopt-0.8.1
dtoa-0.4.2
env_logger-0.4.3
error-chain-0.11.0
filetime-0.1.10
flate2-0.2.19
foreign-types-0.2.0
fs2-0.4.2
gcc-0.3.45
gdi32-sys-0.2.0
git2-0.6.4
git2-curl-0.7.0
glob-0.2.11
hex-0.2.0
idna-0.1.1
itoa-0.3.4
jobserver-0.1.8
kernel32-sys-0.2.2
lazy_static-0.2.8
libc-0.2.21
libgit2-sys-0.6.7
libssh2-sys-0.2.5
libz-sys-1.0.13
log-0.3.7
matches-0.1.4
memchr-1.0.2
miniz-sys-0.1.9
miow-0.2.1
net2-0.2.27
num-traits-0.1.40
num_cpus-1.3.0
openssl-0.9.11
openssl-probe-0.1.1
openssl-sys-0.9.11
pkg-config-0.3.9
psapi-sys-0.1.0
quote-0.3.15
rand-0.3.15
redox_syscall-0.1.17
redox_termios-0.1.1
regex-0.2.2
regex-syntax-0.4.1
rustc-demangle-0.1.5
scoped-tls-0.1.0
semver-0.7.0
semver-parser-0.7.0
serde-1.0.16
serde_derive-1.0.16
serde_derive_internals-0.16.0
serde_ignored-0.0.3
serde_json-1.0.5
shell-escape-0.1.3
strsim-0.6.0
syn-0.11.11
synom-0.11.3
tar-0.4.11
tempdir-0.3.5
termcolor-0.3.3
termion-1.5.1
thread_local-0.3.4
time-0.1.36
toml-0.4.5
unicode-bidi-0.2.5
unicode-normalization-0.1.4
unicode-xid-0.0.4
unreachable-1.0.0
url-1.4.0
user32-sys-0.2.0
utf8-ranges-1.0.0
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
wincolor-0.1.4
ws2_32-sys-0.2.1
"

inherit cargo

DESCRIPTION="Generates an ebuild for a package using the in-tree eclasses."
HOMEPAGE="https://github.com/cardoe/cargo-ebuild"
SRC_URI="$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="MIT/Apache-2.0" # Update to proper Gentoo format
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

COMMON_DEPEND="sys-libs/zlib
        !libressl? ( dev-libs/openssl:0= )
        libressl? ( dev-libs/libressl:0= )
        net-libs/libssh2
        net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
        net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
        dev-util/cmake
        sys-apps/coreutils
        sys-apps/diffutils
        sys-apps/findutils
        sys-apps/sed"

src_prepare() {
	default
	cd ${WORKDIR}/cargo_home/gentoo || die
	eapply ${FILESDIR}/llvm-objcopy-compat.patch
}
