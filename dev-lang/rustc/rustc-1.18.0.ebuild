# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )

inherit python-any-r1 versionator toolchain-funcs llvm

ABI_VER="$(get_version_component_range 1-2)"
SLOT="stable/${ABI_VER}"
KEYWORDS="~amd64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz -> ${P}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang debug doc -jemalloc +libcxx +source +system-llvm"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
	system-llvm? ( >=sys-devel/llvm-3.8.1-r2:=
		<sys-devel/llvm-5.0.0:= )
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
	if use elibc_musl; then
		eapply "${FILESDIR}"/link-musl-dynamically.patch
		eapply "${FILESDIR}"/libunwind-shared.patch
		eapply "${FILESDIR}"/no-compiler-rt.patch
		eapply "${FILESDIR}"/dont-use-no_default_libraries.patch
		eapply "${FILESDIR}"/dont-install-crtfiles.patch
	fi

	eapply "${FILESDIR}"/configured-cargo-rust.patch
	eapply "${FILESDIR}"/do-not-strip-when-debug.patch
	eapply "${FILESDIR}"/link-llvm-shared.patch

	eapply_user
}

src_configure() {
	einfo "Setting up config.toml for target"

	local cbuild="${CBUILD//-/ }"
	read -a arr <<<$cbuild
	local rust_target="${arr[0]}-unknown-${arr[2]}-${arr[3]}"

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
build = "${rust_target}"
host = ["${rust_target}"]
target = ["${rust_target}"]

[install]
prefix = "${EPREFIX}/usr"
libdir = "$(get_libdir)"
docdir = "share/doc/${P}"
mandir = "share/${P}/man"

[rust]
optimize = $(toml_usex !debug)
debuginfo = $(toml_usex debug)
debug-assertions = $(toml_usex debug)
use-jemalloc = $(toml_usex jemalloc)
default-linker = "${linker}"
default-ar = "${archiver}"
rpath = false

[target.${rust_target}]
cc = "${c_compiler}"
cxx = "${cxx_compiler}"
llvm-config = "${llvm_config}"
EOF
}

src_compile() {
	export RUST_BACKTRACE=1
	export LLVM_LINK_SHARED=1

	./x.py build --verbose || die
}

src_install() {
	env DESTDIR="${D}" ./x.py dist --install || die

	pushd ${D}/usr/lib || die

	# symlinks instead of copies
	ln -sf rustlib/*/lib/*.so . || die

	popd >/dev/null

	if use source; then
		pushd ${S}/src
		mkdir -p ${D}/usr/src/${P}
		find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/src/${P} \; || die
		popd >/dev/null
	fi
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
