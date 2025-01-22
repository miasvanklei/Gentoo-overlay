# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 )

inherit git-r3 llvm-r1 pax-utils optfeature toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"

EGIT_REPO_URI="https://github.com/JuliaLang/julia.git"

# correct versions for stdlibs are in deps/checksums
# for everything else, run with network-sandbox and wait for the crash
STDLIBS=(
	# repo    package name    hash
	"JuliaIO ArgTools.jl 1314758ad02ff5e9e5ca718920c6c633b467a84a"
	"JuliaLang DelimitedFiles.jl db79c842f95f55b1f8d8037c0d3363ab21cd3b90"
	"JuliaLang Distributed.jl c6136853451677f1957bec20ecce13419cde3a12"
	"JuliaLang Downloads.jl e692e77fb5427bf3c6e81514b323c39a88217eec"
	"JuliaLang JuliaSyntaxHighlighting.jl 19bd57b89c648592155156049addf67e0638eab1"
	"JuliaPackaging LazyArtifacts.jl e4cfc39598c238f75bdfdbdb3f82c9329a5af59c"
	"JuliaLang LinearAlgebra.jl 1137b4c7fa8297cef17c4ae0982d7d89d4ab7dd8"
	"JuliaLang NetworkOptions.jl c090626d3feee6d6a5c476346d22d6147c9c6d2d"
	"JuliaLang Pkg.jl bc9fb21b1f2d72038491eff938673fc5fbc99445"
	"JuliaCrypto SHA.jl 8fa221ddc8f3b418d9929084f1644f4c32c9a27e"
	"JuliaLang SparseArrays.jl 212981bf29b03ba460d3251ee9aa4399931b3f2d"
	"JuliaStats Statistics.jl d49c2bf4f81e1efb4980a35fe39c815ef8396297"
	"JuliaLang StyledStrings.jl 8985a37ac054c37d084a03ad2837208244824877"
	"JuliaSparse SuiteSparse.jl e8285dd13a6d5b5cf52d8124793fc4d622d07554"
	"JuliaLang Tar.jl 1114260f5c7a7b59441acadca2411fa227bb8a3b"
	"JuliaWeb LibCURL.jl a65b64f6eabc932f63c2c0a4a5fb5d75f3e688d0"
)

BUNDLED_DEPS=(
	"intel ittapi 0014aec56fea2f30c1374f40861e1bccdd53d0cb"
	"vtjnash libwhich 99a0ea12689e41164456dba03e93bc40924de880"
	"JuliaLang libuv af4172ec713ee986ba1a989b9e33993a07c60c9e"
	"JuliaLinearAlgebra libblastrampoline b127bc8dd4758ffc064340fff2aef4ead552f386"
	"JuliaLang JuliaSyntax.jl dfd1d69b153eb119873035e62993a109b27192f0"
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
	app-arch/p7zip
	dev-libs/gmp:0=
	>=dev-libs/libpcre2-10.23:0=[jit,unicode]
	dev-libs/mpfr:0=
	dev-libs/libutf8proc:0=[-cjk]
	dev-libs/libgit2:0/1.9
	dev-libs/openssl
	dev-util/patchelf
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
	llvm-runtimes/libunwind:=
	llvm-core/llvm:=
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
	"${FILESDIR}"/fix-hardcoded-libs.patch
	"${FILESDIR}"/disable-install-docs.patch
	"${FILESDIR}"/support-compiler_rt_libunwind.patch
	"${FILESDIR}"/fix-textrel.patch
	"${FILESDIR}"/dont-build-twice.patch
	"${FILESDIR}"/dont-link-atomic.patch
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
	git-r3_fetch
	git-r3_checkout

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
	dostrip -x /usr/share/${PN}/compiled/*/*/*.so

	# Link ca-certificates.crt, bug: https://bugs.gentoo.org/888978
	dosym -r /etc/ssl/certs/ca-certificates.crt /usr/share/julia/cert.pem
}

pkg_postinst() {
	optfeature "Julia Plots" sci-visualization/gr
}
