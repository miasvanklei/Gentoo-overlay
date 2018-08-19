# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit python-any-r1 versionator toolchain-funcs llvm

SLOT="0"
KEYWORDS="~amd64"

CARGO_DEPEND_VERSION="0.$(($(get_version_component_range 2))).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

MY_P="rustc-${PV}"
SRC_URI="https://static.rust-lang.org/dist/${MY_P}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+cargo debug doc libressl +rls +rustfmt -jemalloc"

RDEPEND="jemalloc? ( dev-libs/jemalloc )
	sys-devel/llvm"
DEPEND="${RDEPEND}
        ${PYTHON_DEPS}
        || (
                >=sys-devel/gcc-4.7
                >=sys-devel/clang-3.5
        )
        cargo? ( !dev-util/cargo
		sys-libs/zlib
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		net-libs/libssh2
		net-libs/http-parser
		net-misc/curl[ssl]
	)
        rustfmt? ( !dev-util/rustfmt )
        dev-util/cmake
"
PDEPEND="!cargo? ( >=dev-util/cargo-${CARGO_DEPEND_VERSION} )"


RDEPEND="sys-devel/llvm:="

S="${WORKDIR}/${MY_P}-src"

toml_usex() {
	usex "$1" true false
}

pkg_setup() {
	python-any-r1_pkg_setup
	llvm_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/static.patch
	"${FILESDIR}"/system-llvm.patch
	"${FILESDIR}"/musl.patch
	"${FILESDIR}"/use-libc++.patch
	"${FILESDIR}"/fix-analysis-path.patch
)

src_configure() {
	einfo "Setting up config.toml for target"

	local llvm_config="$(get_llvm_prefix)/bin/${CBUILD}-llvm-config"

	local extended="false" tools=""
	if use cargo; then
		extended="true"
		tools="\"cargo\","
	fi
	if use rls; then
		extended="true"
		tools="\"rls\",$tools"
	fi
	if use rustfmt; then
		extended="true"
		tools="\"rustfmt\",$tools"
	fi

	cat <<- EOF > "${S}"/config.toml
	[llvm]
	link-shared = true
	[build]
	build = "${CBUILD}"
	host = ["${CHOST}"]
	target = ["${CBUILD}"]
	cargo = "/usr/bin/cargo"
	rustc = "/usr/bin/rustc"
	docs = $(toml_usex doc)
	submodules = false
	python = "${EPYTHON}"
	vendor = true
	extended = ${extended}
	tools = [${tools}]
	[install]
	prefix = "${EPREFIX}/usr"
	libdir = "$(get_libdir)"
	mandir = "share/${PN}/man"
	docdir = "share/doc/${PN}"
	[rust]
	optimize = $(toml_usex !debug)
	debuginfo = $(toml_usex debug)
	debug-assertions = $(toml_usex debug)
	use-jemalloc = $(toml_usex jemalloc)
	default-linker = "$(tc-getCC)"
	rpath = false
	[target.${CBUILD}]
	cc = "$(tc-getBUILD_CC)"
	cxx = "$(tc-getBUILD_CXX)"
	llvm-config = "${llvm_config}"
	linker = "$(tc-getCC)"
	ar = "$(tc-getAR)"
	EOF
}

src_compile() {
	${EPYTHON} x.py build --config="${S}"/config.toml --exclude src/tools/miri || die
}

src_install() {
	default

	local rcbuild="build/${CBUILD}"
	local obj="${rcbuild}/stage2"
	local sobj="${rcbuild}/stage1-std/${CBUILD}"
	local tobj="${rcbuild}/stage2-tools/${CBUILD}/release"

	# install binaries
	dobin "${obj}/bin/rustc" "${obj}/bin/rustdoc"
	dobin src/etc/rust-gdb src/etc/rust-lldb

	if use cargo; then
		dobin "${tobj}"/cargo
	fi
	if use rls; then
		dobin "${tobj}"/rls
	fi
	if use rustfmt; then
		dobin "${tobj}"/rustfmt
		dobin "${tobj}"/cargo-fmt
	fi

	# install libraries
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/rustlib"

	# install analysis for rls
	insinto "/usr/$(get_libdir)/rustlib/analysis"
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
	RUST_SRC_PATH="/usr/lib/rustlib/src"
	EOF
	doenvd "${T}"/50${PN}

	# install sources needed for go to definition and racer
	pushd ${S}/src
	mkdir -p ${D}/usr/lib/rustlib/src/rust/src
	find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/lib/rustlib/src \; || die
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
