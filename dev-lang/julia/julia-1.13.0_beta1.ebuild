# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 20 21 )
MY_PV="${PV/_/-}"

inherit llvm-r1 pax-utils optfeature toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="https://github.com/JuliaLang/julia/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"


# correct versions for stdlibs are in stdlib/{package_name}.version
# updated versions can be found by running find_dependencies.sh in ${FILES}
# for everything else, run with network-sandbox and wait for the crash

STDLIBS=(
	# repo    package name    hash
	"JuliaIO ArgTools.jl 89d19599208c02bfa9609d4578ab72eabe6e8eee"
	"JuliaData DelimitedFiles.jl aac8c59e58cbf961fa15baf4d866901d9d1e6980"
	"JuliaLang Distributed.jl 661112ef29b8d371b8612b94a629c0bbcf3d36f7"
	"JuliaLang Downloads.jl 4e20d029c723199c0b8ea0e2418ff240d25ddaef"
	"julialang JuliaSyntaxHighlighting.jl 2817dbaba2a4abaad91a5ad754558840d95ccf2e"
	"JuliaPackaging LazyArtifacts.jl e4cfc39598c238f75bdfdbdb3f82c9329a5af59c"
	"JuliaWeb LibCURL.jl 9ea5c5d6f5b88615d9fe23379b7f951787b99fd3"
	"JuliaLang LinearAlgebra.jl 47864521739992c57be3138128458ecf7d339567"
	"JuliaLang NetworkOptions.jl 46e14ef20739c8011b105c339146062cd0e2938c"
	"JuliaLang Pkg.jl 4f9884fdb867f2c928ba43dc41da5f150aaec4ab"
	"JuliaCrypto SHA.jl 876bc0400f9a457eb2736388fc3d0fbe9460fc7d"
	"JuliaSparse SparseArrays.jl 26c80c8b45dc2dca92788332a40a99b6c360d05a"
	"JuliaStats Statistics.jl 22dee82f9824d6045e87aa4b97e1d64fe6f01d8d"
	"JuliaLang StyledStrings.jl 68bf7b1f83f334391dc05fda34f48267e04e2bd0"
	"JuliaSparse SuiteSparse.jl e8285dd13a6d5b5cf52d8124793fc4d622d07554"
	"JuliaIO Tar.jl 9dd8ed1b5f8503804de49da9272150dcc18ca7c7"
)

# correct versions for deps are in deps/{package_name}.version
BUNDLED_DEPS=(
	"JuliaLang JuliaSyntax.jl 99e975a726a82994de3f8e961e6fa8d39aed0d37"
	"intel ittapi 0014aec56fea2f30c1374f40861e1bccdd53d0cb"
	"vtjnash libwhich 99a0ea12689e41164456dba03e93bc40924de880"
	"JuliaLang libuv b21d6d84e46f6c97ecbc8e4e8a8ea6ad98049ea8"
	"JuliaLinearAlgebra libblastrampoline 072b5f67895bec0b92f8c83194567c1c48e9833d"
)

update_SRC_URI() {
	local src_uris=( "${STDLIBS[@]}" "${BUNDLED_DEPS[@]}" )

	local repo pn pv
	for p in "${src_uris[@]}"; do
		set -- $p
		repo=$1 pn=$2 pv=$3

		SRC_URI+=" https://api.github.com/repos/${repo}/${pn}/tarball/${pv} -> ${PN}-${pn}-${pv}.tar.gz"
	done
}

update_SRC_URI

S="${WORKDIR}/${P/_/-}"

LICENSE="MIT"
SLOT="0"

RDEPEND+="
	app-arch/7zip
	dev-libs/gmp:0=
	>=dev-libs/libpcre2-10.23:0=[jit,unicode]
	dev-libs/mpfr:0=
	dev-libs/libutf8proc:0=[-cjk]
	dev-libs/libgit2:0/1.9
	dev-libs/openssl
	dev-util/patchelf
	net-misc/curl[http2,ssh]
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/openblas:0=
	>=sci-libs/suitesparse-7.10.0
	sys-libs/zlib:0=
	>=sci-mathematics/dsfmt-2.2.4
	virtual/lapack
	|| (
		llvm-runtimes/libgcc
		sys-devel/gcc
	)
	amd64? (
		virtual/blas[index64]
		virtual/lapack[index64]
	)
	arm64? (
		virtual/blas[index64]
		virtual/lapack[index64]
	)
"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/dont-assume-gfortran.patch
	"${FILESDIR}"/fix-hardcoded-libs.patch
	"${FILESDIR}"/disable-install-docs.patch
	"${FILESDIR}"/support-libcxx-libunwind.patch
	"${FILESDIR}"/fix-textrel.patch
	"${FILESDIR}"/dont-build-twice.patch
	"${FILESDIR}"/link-llvm-shared.patch
	"${FILESDIR}"/llvm-21.patch
	"${FILESDIR}"/fix-private-libdir.patch
	"${FILESDIR}"/fix-system-zstd.patch
	"${FILESDIR}"/patchelf-system-llvm.patch
)

pkg_setup() {
	llvm-r1_pkg_setup
}

copy_bundled_deps() {
	local dest="$1"
	shift
	local filenames=("$@")

	mkdir -p "${S}/${dest}/srccache/"
	for p in "${filenames[@]}"; do
		set -- $p
		repo=$1 pn=$2 pv=$3
		filename="${pn}-${pv}.tar.gz"

		cp "${DISTDIR}/${PN}-${filename}" "${S}/${dest}/srccache/${filename/.jl/}" || die
	done

}

src_unpack() {
	default

	copy_bundled_deps stdlib "${STDLIBS[@]}"
	copy_bundled_deps deps "${BUNDLED_DEPS[@]}"

	rename "lib" "" "${S}"/deps/srccache/libblastrampoline-* || die
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
		override FC:=$(tc-getFC)
		override CXX:=$(tc-getCXX)
		override AR:=$(tc-getAR)

		BUNDLE_DEBUG_LIBS:=0
		USE_BINARYBUILDER:=0
		USE_LLVM_LIBUNWIND:=1
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
		USE_SYSTEM_OPENSSL:=1
		USE_SYSTEM_LIBSSH2:=1
		USE_SYSTEM_NGHTTP2:=1
		USE_SYSTEM_CURL:=1
		USE_SYSTEM_LIBGIT2:=1
		USE_SYSTEM_PATCHELF:=1
		USE_SYSTEM_ZLIB:=1
		USE_SYSTEM_P7ZIP:=1
		USE_SYSTEM_ZSTD:=1
		WITH_TERMINFO=0
		VERBOSE:=1
	EOF
}

src_compile() {
	# Julia accesses /proc/self/mem on Linux.
	addpredict /proc/self/mem

	emake release
	pax-mark m "$(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')"
}

src_install() {
	emake install DESTDIR="${D}"

	dodoc README.md

	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
	rmdir "${ED}"/usr/etc || die
	rmdir "${ED}"/usr/share/doc/julia || die

	# Prevent compiled modules from being stripped,
	# as it changes their checksum so Julia refuses to load them
	for i in $(find usr/share/julia/compiled/v$(ver_cut 1-2) -name "*.so"); do
		dostrip -x /$i
	done

	# Link ca-certificates.crt, bug: https://bugs.gentoo.org/888978
	dosym -r /etc/ssl/certs/ca-certificates.crt /usr/share/julia/cert.pem
}

pkg_postinst() {
	optfeature "Julia Plots" sci-visualization/gr
}
