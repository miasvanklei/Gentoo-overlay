# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )

inherit python-any-r1 versionator toolchain-funcs llvm

SLOT="0"
KEYWORDS="~amd64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz -> ${P}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang -debug doc -jemalloc +libcxx +source +system-llvm"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
	system-llvm? ( sys-devel/llvm:4 )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
"

S=${WORKDIR}/${P}-src

toml_usex() {
	usex "$1" true false
}

pkg_setup() {
	python-any-r1_pkg_setup
	llvm_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}"/llvm-5.0.patch
	eapply "${FILESDIR}"/musl.patch
	eapply "${FILESDIR}"/configured-cargo-rustc.patch
	eapply "${FILESDIR}"/do-not-strip-when-debug.patch

	eapply_user
}

src_configure() {
	einfo "Setting up config.toml for target"

	local rtarget="x86_64-unknown-linux-musl"

	local archiver="$(tc-getAR)"
	local linker="$(tc-getCC)"

	local llvm_config="$(get_llvm_prefix)/bin/${CBUILD}-llvm-config"
	local c_compiler="$(tc-getBUILD_CC)"
	local cxx_compiler="$(tc-getBUILD_CXX)"
	if use clang ; then
		c_compiler="${CBUILD}-clang"
		cxx_compiler="${CBUILD}-clang++"
	fi

	cat > config.toml <<EOF
[build]
cargo = "/usr/bin/cargo"
rustc = "/usr/bin/rustc"
build = "${rtarget}"
host = ["${rtarget}"]
target = ["${rtarget}"]

[install]
prefix = "${EPREFIX}/usr"
libdir = "$(get_libdir)"
docdir = "share/doc/${PN}"
mandir = "share/${PN}/man"

[rust]
optimize = $(toml_usex !debug)
debuginfo = $(toml_usex debug)
debug-assertions = $(toml_usex debug)
use-jemalloc = $(toml_usex jemalloc)
default-linker = "${linker}"
default-ar = "${archiver}"
rpath = false

[target.${rtarget}]
cc = "${c_compiler}"
cxx = "${cxx_compiler}"
llvm-config = "${llvm_config}"
EOF
}

src_compile() {
	export RUST_BACKTRACE=1
	export LLVM_LINK_SHARED=1
	export RUSTFLAGS="-L$(get_llvm_prefix)/lib"
	./x.py build --verbose || die
}

src_install() {
	export RUST_BACKTRACE=1
	export LLVM_LINK_SHARED=1
	export RUSTFLAGS="-L$(get_llvm_prefix)/lib"

	DESTDIR="${D}" ./x.py dist --install --verbose || die

	pushd ${D}/usr/lib || die

	# remove copy
	rm -r *.so || die

	popd >/dev/null

	if use source; then
		pushd ${S}/src
		mkdir -p ${D}/usr/src/${PN}
		find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/src/${PN} \; || die
		popd >/dev/null
	fi

        cat <<-_EOF_ > "${T}/10rust" || die
LDPATH=/usr/lib/rustlib/${CHOST}/lib
_EOF_
        doenvd "${T}/10rust"
}

pkg_postinst() {
	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb"

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}
