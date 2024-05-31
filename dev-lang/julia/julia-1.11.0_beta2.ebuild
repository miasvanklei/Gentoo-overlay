# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm pax-utils optfeature toolchain-funcs

# correct versions for stdlibs are in deps/checksums
# for everything else, run with network-sandbox and wait for the crash

MY_LIBUV_V="ca3a5a431a1c37859b6508e6b2a288092337029a"
MY_BLASTRAMPOLINE_V="81316155d4838392e8462a92bcac3eebe9acd0c7"
MY_LIBWHICH_V="81e9723c0273d78493dc8c8ed570f68d9ce7e89e"
MY_ITTAPI_V="0014aec56fea2f30c1374f40861e1bccdd53d0cb"

ARGTOOLS_V="997089b9cd56404b40ff766759662e16dc1aab4b"
DELIMITEDFILES_V="db79c842f95f55b1f8d8037c0d3363ab21cd3b90"
DISTRIBUTED_V="41c01069533e22a6ce6b794746e4b3aa9f5a25cd"
DOWNLOADS_V="a9d274ff6588cc5dbfa90e908ee34c2408bab84a"
JULIASYNTAX_V="4f1731d6ce7c2465fc21ea245110b7a39f34658a"
JULIASYNTAXHIGHLIGHTING_V="4110caaf4fcdf0c614fd3ecd7c5bf589ca82ac63"
LAZYARTIFACTS_V="e9a36338d5d0dfa4b222f4e11b446cbb7ea5836c"
NETWORKOPTIONS_V="aab83e5dd900c874826d430e25158dff43559d78"
PKG_V="f112626414a4f666306adb84936ea85aec77c89d"
SHA_V="aaf2df61ff8c3898196587a375d3cf213bd40b41"
SPARSEARRAYS_V="cb602d7b7cf46057ddc87d23cda2bdd168a548ac"
STATISTICS_V="68869af06e8cdeb7aba1d5259de602da7328057f"
STYLEDSTRINGS_V="ac472083359dde956aed8c61d43b8158ac84d9ce"
SUITEPARSE_V="e8285dd13a6d5b5cf52d8124793fc4d622d07554"
TAR_V="81888a33704b233a2ad6f82f84456a1dd82c87f0"
LIBCURL_V="a65b64f6eabc932f63c2c0a4a5fb5d75f3e688d0"

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"

SRC_URI="
	https://github.com/JuliaLang/julia/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	https://api.github.com/repos/intel/ittapi/tarball/${MY_ITTAPI_V} -> ${PN}-ittapi-${MY_ITTAPI_V}.tar.gz
	https://api.github.com/repos/vtjnash/libwhich/tarball/${MY_LIBWHICH_V} -> ${PN}-libwhich-${MY_LIBWHICH_V}.tar.gz
	https://api.github.com/repos/JuliaLang/libuv/tarball/${MY_LIBUV_V} -> ${PN}-libuv-${MY_LIBUV_V}.tar.gz
	https://api.github.com/repos/JuliaLinearAlgebra/libblastrampoline/tarball/${MY_BLASTRAMPOLINE_V} -> ${PN}-blastrampoline-${MY_BLASTRAMPOLINE_V}.tar.gz
	https://api.github.com/repos/JuliaIO/ArgTools.jl/tarball/${ARGTOOLS_V} -> ${PN}-stdlib-ArgTools-${ARGTOOLS_V}.tar.gz
	https://api.github.com/repos/JuliaLang/DelimitedFiles.jl/tarball/${DELIMITEDFILES_V} -> ${PN}-stdlib-DelimitedFiles-${DELIMITEDFILES_V}.tar.gz
	https://api.github.com/repos/JuliaLang/Distributed.jl/tarball/${DISTRIBUTED_V} -> ${PN}-stdlib-Distributed-${DISTRIBUTED_V}.tar.gz
	https://api.github.com/repos/JuliaLang/Downloads.jl/tarball/${DOWNLOADS_V} -> ${PN}-stdlib-Downloads-${DOWNLOADS_V}.tar.gz
	https://api.github.com/repos/JuliaLang/JuliaSyntax.jl/tarball/${JULIASYNTAX_V} -> ${PN}-JuliaSyntax-${JULIASYNTAX_V}.tar.gz
	https://api.github.com/repos/JuliaLang/JuliaSyntaxHighlighting.jl/tarball/${JULIASYNTAXHIGHLIGHTING_V} -> ${PN}-stdlib-JuliaSyntaxHighlighting-${JULIASYNTAXHIGHLIGHTING_V}.tar.gz
	https://api.github.com/repos/JuliaPackaging/LazyArtifacts.jl/tarball/${LAZYARTIFACTS_V} -> ${PN}-stdlib-LazyArtifacts-${LAZYARTIFACTS_V}.tar.gz
	https://api.github.com/repos/JuliaLang/NetworkOptions.jl/tarball/${NETWORKOPTIONS_V} -> ${PN}-stdlib-NetworkOptions-${NETWORKOPTIONS_V}.tar.gz
	https://api.github.com/repos/JuliaLang/Pkg.jl/tarball/${PKG_V} -> ${PN}-stdlib-Pkg-${PKG_V}.tar.gz
	https://api.github.com/repos/JuliaCrypto/SHA.jl/tarball/${SHA_V} -> ${PN}-stdlib-SHA-${SHA_V}.tar.gz
	https://api.github.com/repos/JuliaLang/SparseArrays.jl/tarball/${SPARSEARRAYS_V} -> ${PN}-stdlib-SparseArrays-${SPARSEARRAYS_V}.tar.gz
	https://api.github.com/repos/JuliaStats/Statistics.jl/tarball/${STATISTICS_V} -> ${PN}-stdlib-Statistics-${STATISTICS_V}.tar.gz
	https://api.github.com/repos/JuliaLang/StyledStrings.jl/tarball/${STYLEDSTRINGS_V} -> ${PN}-stdlib-StyledStrings-${STYLEDSTRINGS_V}.tar.gz
	https://api.github.com/repos/JuliaSparse/SuiteSparse.jl/tarball/${SUITEPARSE_V} -> ${PN}-stdlib-SuiteSparse-${SUITEPARSE_V}.tar.gz
	https://api.github.com/repos/JuliaLang/Tar.jl/tarball/${TAR_V} -> ${PN}-stdlib-Tar-${TAR_V}.tar.gz
	https://api.github.com/repos/JuliaWeb/LibCURL.jl/tarball/${LIBCURL_V} -> ${PN}-stdlib-LibCURL-${LIBCURL_V}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

LLVM_MAX_SLOT=18

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
	sci-libs/cholmod:0/5
	sci-libs/colamd:0/3
	sci-libs/cxsparse:0/4
	sci-libs/fftw:3.0=[threads]
	sci-libs/klu:0/2
	sci-libs/ldl:0/3
	sci-libs/openblas:0
	sci-libs/openlibm:0
	sci-libs/spqr:0/4
	sci-libs/rbio:0/4
	sci-libs/umfpack:0/6
	>=sci-mathematics/dsfmt-2.2.4
	sys-libs/llvm-libunwind:=
	sys-devel/llvm:18=
	sys-libs/zlib:0=
	amd64? ( sci-libs/openblas[index-64bit] )
"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/no_symlink_llvm.patch
	"${FILESDIR}"/link-llvm-shared.patch
	"${FILESDIR}"/dont-assume-gfortran.patch
	"${FILESDIR}"/dont-assume-binutils.patch
	"${FILESDIR}"/fix-hardcoded-libs.patch
	"${FILESDIR}"/disable-install-docs.patch
	"${FILESDIR}"/support-compiler_rt_libunwind.patch
	"${FILESDIR}"/llvm-17.patch
	"${FILESDIR}"/llvm-18.patch
	"${FILESDIR}"/fix-textrel.patch
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
