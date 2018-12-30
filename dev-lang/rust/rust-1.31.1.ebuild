# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit llvm multiprocessing toolchain-funcs python-any-r1 versionator

SLOT="0"
KEYWORDS="~amd64"

CARGO_DEPEND_VERSION="0.$(($(get_version_component_range 2))).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/rustc-${PV}-src.tar.xz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="+clippy debug doc -jemalloc libressl +rls +rustfmt"

COMMON_DEPEND="jemalloc? ( dev-libs/jemalloc )
		sys-libs/zlib
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		net-libs/libssh2
		net-libs/http-parser:=
		net-misc/curl[ssl]
		>=sys-devel/llvm-6:="
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	|| (
		>=sys-devel/clang-3.5
		>=sys-devel/gcc-4.7
	)
	dev-util/cmake"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo
	rustfmt? ( !dev-util/rustfmt )"


S="${WORKDIR}/rustc-${PV}-src"

toml_usex() {
	usex "$1" true false
}

pkg_setup() {
	python-any-r1_pkg_setup
	llvm_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/0001-cleanup-musl-target.patch
	"${FILESDIR}"/0002-add-gentoo-target.patch
        "${FILESDIR}"/0003-liblibc-linkage.patch
        "${FILESDIR}"/0004-libunwind-linkage.patch
	"${FILESDIR}"/0005-libc++-linkage.patch
	"${FILESDIR}"/0006-musl-fix-static-linking.patch
	"${FILESDIR}"/0007-static-pie-support.patch
	"${FILESDIR}"/0008-system-llvm.patch
	"${FILESDIR}"/0009-fix-analysis-path.patch
	"${FILESDIR}"/0010-Move-debugger-scripts-to-usr-share-rust.patch
)

src_configure() {
	einfo "Setting up config.toml for target"

	local llvm_config="$(get_llvm_prefix)/bin/${CBUILD}-llvm-config"

	local extended="true" tools="\"cargo\","
	if use clippy; then
		tools="\"clippy\",$tools"
	fi
	if use rls; then
		tools="\"rls\",\"analysis\",\"src\",$tools"
	fi
	if use rustfmt; then
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
	docdir = "share/doc/${PN}"
	mandir = "share/${PN}/man"
	[rust]
	optimize = $(toml_usex !debug)
	debuginfo = $(toml_usex debug)
	debug-assertions = $(toml_usex debug)
	use-jemalloc = $(toml_usex jemalloc)
	default-linker = "$(tc-getCC)"
        channel = "stable"
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
	cat <<- EOF >> "${S}"/config.env
		RUST_BACKTRACE=1
		RUSTC_CRT_STATIC="false"
		LIBGIT2_SYS_USE_PKG_CONFIG=1
	EOF

	env $(cat "${S}"/config.env)\
	${EPYTHON} ./x.py build --config="${S}"/config.toml -j$(makeopts_jobs) \
        --exclude src/tools/miri || die
}

src_install() {
	default

	local rcbuild="build/${CBUILD}"
	local obj="${rcbuild}/stage2"
	local sobj="${rcbuild}/stage1-std/${CBUILD}"
	local tobj="${rcbuild}/stage2-tools/${CBUILD}/release"

	# Install binaries
	dobin "${obj}"/bin/rustc "${obj}"/bin/rustdoc "${tobj}"/cargo

	dobin src/etc/rust-gdb src/etc/rust-lldb

	if use clippy; then
		dobin "${tobj}"/clippy-driver
		dobin "${tobj}"/cargo-clippy
	fi
	if use rls; then
		dobin "${tobj}"/rls
	fi
	if use rustfmt; then
		dobin "${tobj}"/rustfmt
		dobin "${tobj}"/cargo-fmt
	fi

	# Install libraries
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/rustlib"

	# Delete crt*.o files
	find "${D}" -name "crt*.o" -delete || die

	# Install analysis for rls
	insinto "/usr/$(get_libdir)/rustlib/analysis/${CHOST}"
	doins "${sobj}/release/deps/save-analysis/"*

	# Install COPYRIGHT and LICENSE
	dodoc COPYRIGHT LICENSE-APACHE LICENSE-MIT

	# Pretty printers
	insinto "/usr/$(get_libdir)/rustlib/etc"
	doins src/etc/*pretty*
	doins src/etc/lldb_rust_formatters.py

	# Setup environment
	cat <<-EOF > "${T}"/50${PN}
	LDPATH="/usr/$(get_libdir)/rustlib/${CBUILD}/lib"
	MANPATH="/usr/share/${PN}/man"
	RUST_SRC_PATH="/usr/lib/rustlib/src"
	EOF
	doenvd "${T}"/50${PN}

	# Install sources needed for go to definition and racer
	pushd ${S}/src
	mkdir -p ${D}/usr/lib/rustlib/src/rust/src
	find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/lib/rustlib/src/rust/src \; || die
	popd >/dev/null
}

pkg_postinst() {
	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb."

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
