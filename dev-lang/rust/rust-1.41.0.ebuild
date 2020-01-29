# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit llvm multiprocessing toolchain-funcs python-any-r1

SLOT="0"
KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://dev-static.rust-lang.org/dist/rustc-${PV}-src.tar.xz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="debug doc libressl"

LLVM_MAX_SLOT=9

COMMON_DEPEND="sys-libs/zlib
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		<=dev-libs/libgit2-0.29:=
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
	!dev-util/rustfmt"

S="${WORKDIR}/rustc-${PV}-src"

toml_usex() {
	usex "$1" true false
}

pkg_setup() {
	python-any-r1_pkg_setup
	llvm_pkg_setup
}

clear_vendor_checksums() {
	sed -i 's/\("files":{\)[^}]*/\1/' vendor/$1/.cargo-checksum.json
}

src_prepare() {
	eapply "${FILESDIR}"/0001-Remove-nostdlib-and-musl_root-from-musl-targets.patch
	eapply "${FILESDIR}"/0003-libc-linkage.patch
	eapply "${FILESDIR}"/0004-libunwind-linkage.patch
	eapply "${FILESDIR}"/0005-libc++-linkage.patch
	eapply "${FILESDIR}"/0006-musl-fix-static-linking.patch
	eapply "${FILESDIR}"/0007-add-gentoo-target.patch
	eapply "${FILESDIR}"/0008-static-pie.patch
	eapply "${FILESDIR}"/0009-Move-debugger-scripts-to-usr-share-rust.patch
	eapply "${FILESDIR}"/0010-libgit2.patch
	eapply "${FILESDIR}"/0011-fix-analysis-path.patch

	eapply_user

	clear_vendor_checksums libc
	clear_vendor_checksums libgit2-sys
}


src_configure() {
	einfo "Setting up config.toml for target"

	cat <<- EOF > "${S}"/config.toml
	[llvm]
	link-shared = true
	[build]
	host = ["${CHOST}"]
	build = "${CHOST}"
	target = ["${CHOST}"]
	cargo = "/usr/bin/cargo"
	rustc = "/usr/bin/rustc"
	docs = $(toml_usex doc)
	submodules = false
	python = "${EPYTHON}"
	vendor = true
	extended = true
	[install]
	prefix = "${EPREFIX}/usr"
	libdir = "$(get_libdir)"
	docdir = "share/doc/${PN}"
	mandir = "share/${PN}/man"
	[rust]
	optimize = $(toml_usex !debug)
	debug = $(toml_usex debug)
	debug-assertions = $(toml_usex debug)
	default-linker = "$(tc-getCC)"
	channel = "stable"
	rpath = false
	[target.${CHOST}]
	llvm-config = "$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
	crt-static = false
	EOF
}

src_compile() {
	cat <<- EOF >> "${S}"/config.env
		CARGO_BUILD_PIPELINING=true
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

	dobin "${tobj}"/clippy-driver
	dobin "${tobj}"/cargo-clippy
	dobin "${tobj}"/rls
	dobin "${tobj}"/rustfmt
	dobin "${tobj}"/cargo-fmt

	# Install libraries
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/rustlib"

	# Delete crt*.o files
	find "${D}" -name "crt*.o" -delete || die

	# Install analysis for rls
	insinto "/usr/$(get_libdir)/rustlib/${CHOST}/analysis"
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

	# Install sources needed for rls
	pushd ${S}/src
	mkdir -p ${D}/usr/lib/rustlib/src
	find lib* -name "*.rs" -type f -exec cp --parents {} ${D}/usr/lib/rustlib/src \; || die
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
