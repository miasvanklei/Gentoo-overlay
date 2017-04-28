# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 )

inherit python-any-r1 versionator toolchain-funcs

ABI_VER="$(get_version_component_range 1-2)"
SLOT="stable/${ABI_VER}"
KEYWORDS="~amd64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz -> ${P}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clang debug doc +libcxx +source +system-llvm"
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

src_prepare() {
	if use elibc_musl; then
		eapply "${FILESDIR}"/link-musl-dynamically.patch
		eapply "${FILESDIR}"/libunwind-shared.patch
		eapply "${FILESDIR}"/no-compiler-rt.patch
		eapply "${FILESDIR}"/dont-use-no_default_libraries.patch
		eapply "${FILESDIR}"/dont-install-crtfiles.patch
	fi

	eapply "${FILESDIR}"/do-not-strip-when-debug.patch
	eapply "${FILESDIR}"/link-llvm-shared.patch

	eapply_user
}

src_configure() {
	einfo "Setting up config.toml for target"

	cat > config.toml <<EOF
[build]
cargo = "/usr/bin/cargo"
rustc = "/usr/bin/rustc"
build = "x86_64-unknown-linux-musl"
host = ["x86_64-unknown-linux-musl"]
target = ["x86_64-unknown-linux-musl"]

[install]
prefix = "${D}usr"

[rust]
optimize = true
use-jemalloc = false
channel = "stable"

[target.x86_64-unknown-linux-musl]
llvm-config = "/usr/bin/llvm-config"
EOF
}

src_compile() {
	./x.py build || die
}

src_install() {
	./x.py dist --install || die

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
