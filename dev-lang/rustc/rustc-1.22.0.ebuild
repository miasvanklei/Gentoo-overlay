# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit python-any-r1 versionator toolchain-funcs llvm

SLOT="0"
KEYWORDS="~amd64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${P}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="-debug doc -jemalloc"

RDEPEND="sys-devel/llvm:="

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0"

S=${WORKDIR}/${P}-src

toml_usex() {
	usex "$1" true false
}

pkg_setup() {
	python-any-r1_pkg_setup
	llvm_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}"/musl.patch
	eapply "${FILESDIR}"/do-not-strip-when-debug.patch
	eapply "${FILESDIR}"/debug-hack.patch

	# llvm-5 thinlto: fixed in 1.23.0
	eapply "${FILESDIR}"/llvm-5-thinlto.patch

	eapply_user
}

src_configure() {
	einfo "Setting up config.toml for target"

	local llvm_config="$(get_llvm_prefix)/bin/${CBUILD}-llvm-config"

	cat <<- EOF > config.toml
	[build]
	cargo = "/usr/bin/cargo"
	rustc = "/usr/bin/rustc"
	build = "${CBUILD}"
	host = ["${CHOST}"]
	target = ["${CBUILD}"]
        extended = true
	[install]
	prefix = "${EPREFIX}/usr"
	libdir = "$(get_libdir)/${PN}"
	mandir = "share/${PN}/man"
	docdir = "share/${PN}/doc"
	[rust]
	optimize = $(toml_usex !debug)
	debuginfo = $(toml_usex debug)
	debug-assertions = $(toml_usex debug)
	codegen-units = 1
	use-jemalloc = $(toml_usex jemalloc)
	default-linker = "$(tc-getBUILD_CC)"
	default-ar = "$(tc-getBUILD_AR)"
	rpath = false
	[target.${CBUILD}]
	cc = "$(tc-getBUILD_CC)"
	cxx = "$(tc-getBUILD_CXX)"
	llvm-config = "${llvm_config}"
	EOF
}

src_compile() {
	export LLVM_LINK_SHARED=1
	${EPYTHON} x.py build --verbose || die
}

src_install() {
	default

	local rcbuild="build/${CBUILD}"
	local obj="${rcbuild}/stage2"
	local robj="${rcbuild}/stage2-tools/${CBUILD}"
	local sobj="${rcbuild}/stage1-std/${CBUILD}"

	# install binaries
	dobin "${obj}/bin/rustc" "${obj}/bin/rustdoc" "${robj}/release/rls"
	dobin src/etc/rust-gdb src/etc/rust-lldb

	# install libraries
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/rustlib"

	# install analysis for rls
	insinto "/usr/$(get_libdir)/rustlib/${CBUILD}/analysis"
	doins "${sobj}/release/deps/save-analysis/"*

	# install COPYRIGHT and LICENSE
	dodoc COPYRIGHT LICENSE-APACHE LICENSE-MIT

	# pretty printers
	insinto "/usr/$(get_libdir)/rustlib/etc"
	doins src/etc/*pretty*
	doins src/etc/lldb_rust_formatters.py

	# setup environment
	cat <<-EOF > "${T}"/50${PN}
	LDPATH="/usr/$(get_libdir)/rustlib/${CBUILD}/lib"
	MANPATH="/usr/share/${PN}/man"
	RUST_SRC_PATH="/usr/src/rust"
	EOF
	doenvd "${T}"/50${PN}

	# install source needed for racer
	pushd ${S}/src
	mkdir -p ${D}/usr/src/${PN}
	find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/src/${PN} \; || die
	popd >/dev/null
}

pkg_postinst() {
	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-${PV}."

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
