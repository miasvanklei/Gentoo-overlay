# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm pax-utils optfeature toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"

SRC_URI="https://github.com/JuliaLang/julia/releases/download/v${PV}/${P}-full.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

LLVM_MAX_SLOT=17

RDEPEND+="
	app-arch/p7zip
	dev-libs/gmp:0=
	>=dev-libs/libpcre2-10.23:0=[jit,unicode]
	dev-libs/mpfr:0=
	dev-libs/libutf8proc:0=[-cjk]
	dev-libs/libgit2:=
	dev-util/patchelf
	>=net-libs/mbedtls-2.2
	net-misc/curl[http2,ssh]
	sci-libs/amd:0/3
	sci-libs/arpack:0
	sci-libs/btf:0/2
	sci-libs/camd:0/3
	sci-libs/ccolamd:0/3
	sci-libs/cholmod:0/4
	sci-libs/colamd:0/3
	sci-libs/cxsparse:0/4
	sci-libs/fftw:3.0=[threads]
	sci-libs/klu:0/2
	sci-libs/ldl:0/3
	sci-libs/openblas:0
	sci-libs/openlibm:0
	sci-libs/spqr:0/3
	sci-libs/rbio:0/3
	sci-libs/umfpack:0/6
	>=sci-mathematics/dsfmt-2.2.4
	sys-libs/llvm-libunwind:=
	sys-devel/llvm:17=
	sys-libs/zlib:0=
	amd64? ( sci-libs/openblas[index-64bit] )
"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/no_symlink_llvm.patch
	"${FILESDIR}"/dont-assume-gfortran.patch
	"${FILESDIR}"/dont-assume-binutils.patch
	"${FILESDIR}"/fix-hardcoded-libs.patch
	"${FILESDIR}"/downgrade-suitesparse-deps.patch
	"${FILESDIR}"/disable-install-docs.patch
	"${FILESDIR}"/support-compiler_rt_libunwind.patch
	"${FILESDIR}"/llvm-17.patch
)

S="${WORKDIR}/${P/_/-}"

pkg_setup() {
	llvm_pkg_setup
}

src_unpack() {
	local tounpack=(${A})

	unpack "${A/%\ */}"

	mkdir -p "${S}/deps/srccache/"
	for i in "${tounpack[@]:1}"; do
		cp "${DISTDIR}/${i}" "${S}/deps/srccache/${i#julia-}" || die
	done

	mkdir -p "${S}/stdlib/srccache/"
	for i in $(ls -1 ${S}/deps/srccache/stdlib*); do
		local j=$(basename $i)
		mv "${i}" "${S}/stdlib/srccache/${j#stdlib-}" || die
	done
}

src_prepare() {
	default

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths

	sed -i \
		-e "\|SHIPFLAGS :=|c\\SHIPFLAGS := ${CFLAGS}" \
		Make.inc || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		src/Makefile || die

	# disable doc install starting	git fetching
	sed -i -e 's~install: $(build_depsbindir)/stringreplace docs~install: $(build_depsbindir)/stringreplace~' Makefile || die

	# disable binary wrappers download
	sed -i -e 's|get-$$($(1)_JLL_NAME)_jll||g' stdlib/Makefile || die
}

src_configure() {
	# julia does not play well with the system versions of libuv
	# USE_SYSTEM_LIBM=0 implies using external openlibm
	cat <<-EOF > Make.user
		LOCALBASE:=${EPREFIX}/usr
		override prefix:=${EPREFIX}/usr
		override libdir:=\$(prefix)/$(get_libdir)
		override CC:=$(tc-getCC)
		override CXX:=$(tc-getCXX)
		override AR:=$(tc-getAR)

		BUNDLE_DEBUG_LIBS:=0
		USE_BINARYBUILDER:=0
		USE_SYSTEM_CSL:=1
		USE_SYSTEM_LLVM:=1
		USE_SYSTEM_LLD:=1
		USE_SYSTEM_LIBUNWIND:=1
		USE_SYSTEM_PCRE:=1
		USE_SYSTEM_LIBM:=0
		USE_SYSTEM_OPENLIBM:=1
		USE_SYSTEM_DSFMT:=1
		USE_SYSTEM_BLAS:=1
		USE_SYSTEM_LAPACK:=1
		USE_SYSTEM_GMP:=1
		USE_SYSTEM_MPFR:=1
		USE_SYSTEM_LIBSUITESPARSE:=1
		USE_SYSTEM_LIBUV:=0
		USE_SYSTEM_UTF8PROC:=1
		USE_SYSTEM_MBEDTLS:=1
		USE_SYSTEM_LIBSSH2:=1
		USE_SYSTEM_NGHTTP2:=1
		USE_SYSTEM_CURL:=1
		USE_SYSTEM_LIBGIT2:=1
		USE_SYSTEM_PATCHELF:=1
		USE_SYSTEM_ZLIB:=1
		USE_SYSTEM_P7ZIP:=1
		VERBOSE:=1
	EOF
}

src_compile() {
	# Julia accesses /proc/self/mem on Linux.
	addpredict /proc/self/mem

	default
	pax-mark m "$(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')"
}

src_install() {
	emake install DESTDIR="${D}"

	dodoc README.md

	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
	rmdir "${ED}"/usr/etc || die
	rmdir "${ED}"/usr/share/doc/julia || die

	# Link ca-certificates.crt, bug: https://bugs.gentoo.org/888978
	dosym -r /etc/ssl/certs/ca-certificates.crt /usr/share/julia/cert.pem

	# The appdata directory is deprecated.
	mv "${ED}"/usr/share/{appdata,metainfo}/ || die
}

pkg_postinst() {
	optfeature "Julia Plots" sci-visualization/gr
}
