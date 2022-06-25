# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1
inherit autotools bash-completion-r1 eutils flag-o-matic ghc-package
inherit haskell-cabal multilib multiprocessing pax-utils toolchain-funcs
inherit prefix check-reqs

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="https://www.haskell.org/ghc/"

GHC_PV=${PV}
#GHC_PV=8.10.0.20200123 # uncomment only for -alpha, -beta, -rc ebuilds
GHC_P=${PN}-${GHC_PV} # using ${P} is almost never correct

SRC_URI="
	https://downloads.haskell.org/ghc/${PV/_/-}/${GHC_P}-src.tar.xz
	test? ( https://downloads.haskell.org/ghc/${PV/_/-}/${GHC_P}-testsuite.tar.xz )
"
S="${WORKDIR}"/${GHC_P}

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="doc elfutils gmp numa profile test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.6.1
	dev-libs/gmp:0=
	sys-libs/ncurses:=[unicode(+)]
	dev-libs/libffi:=
	elfutils? ( dev-libs/elfutils )
	numa? ( sys-process/numactl )
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/shake
	dev-haskell/alex
	dev-haskell/quickcheck
	virtual/pkgconfig
	doc? ( app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-python/sphinx
		>=dev-libs/libxslt-1.1.2 )
	test? ( ${PYTHON_DEPS} )
"

needs_python() {
	# test driver is written in python
	use test && return 0
	return 1
}

ghc-check-reqs() {
	# These are pessimistic values (slightly bigger than worst-case)
	# Worst case is UNREG USE=profile ia64. See bug #611866 for some
	# numbers on various arches.
	CHECKREQS_DISK_BUILD=8G
	CHECKREQS_DISK_USR=2G

	"$@"
}

configure_hadrian() {
	pushd hadrian >/dev/null

        cabal-bootstrap
        cabal-configure

	popd >/dev/null
}

compile_hadrian() {
	pushd hadrian >/dev/null

	cabal_src_compile
	./setup copy --destdir="${S}"

	popd >/dev/null
}

pkg_pretend() {
	ghc-check-reqs check-reqs_pkg_pretend
}

pkg_setup() {
	ghc-check-reqs check-reqs_pkg_setup

	[[ ${MERGE_TYPE} == binary ]] && return

	if needs_python; then
		python-any-r1_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	# Fixes panic when compiling some packages
	# https://github.com/gentoo-haskell/gentoo-haskell/issues/1250#issuecomment-1044257595
	# https://gitlab.haskell.org/ghc/ghc/-/issues/21097
	eapply "${FILESDIR}/${PN}-9.0.2-modorigin-semigroup.patch"

	eapply "${FILESDIR}"/${PN}-8.10.1-allow-cross-bootstrap.patch

	# build ghc and libraries only the dynamic way
	eapply "${FILESDIR}"/dynamic.patch

	# build libraries dynamic by default
	eapply "${FILESDIR}"/dynamic-default.patch

	# let portage strip libraries
	eapply "${FILESDIR}"/hadrian-disable-stripping.patch

	# don't set --target, it is wrong anyhow
	eapply "${FILESDIR}"/dont-set-target.patch

	./boot

	eapply_user
	# as we have changed the build system
	eautoreconf
}

src_configure() {
	local econf_args=()

	econf_args+=(
			AR=ar
			CC=${CHOST}-gcc
			LD=ld
			# these should be inferred by GHC but ghc defaults
			# to using bundled tools on windows.
			Windres=${CHOST}-windres
			DllWrap=${CHOST}-dllwrap
			# we set the linker explicitly below
			--disable-ld-override
		)

	econf_args+=(
		--with-system-libffi
		--with-ffi-includes=$($(tc-getPKG_CONFIG) libffi --cflags-only-I | sed -e 's@^-I@@')
	)

	econf ${econf_args[@]} \
		--enable-bootstrap-with-devel-snapshot \
		$(use_enable elfutils dwarf-unwind) \
		$(use_enable numa)
	# build hadrian
	configure_hadrian
}

src_compile() {
	compile_hadrian

	# first build DerivedConstants: build fails otherwise
	local args=( -j )

	if ! use doc; then
		args+=(--docs=none)
	fi

	local flavour="default+disable_stripping"

	if ! use profile; then
		flavour+="+no_profiled_libs"
	fi

	args+=(--flavour=$flavour)

	if ! use gmp; then
		args+=(--bignum=native)
	fi

	local arch=""

	${S}/usr/bin/hadrian _build/stage1/lib/DerivedConstants.h ${args[@]}  || die
	${S}/usr/bin/hadrian ${args[@]} || die
}

src_install() {
	local args=(
		-j
		install
		--prefix=/usr
		--freeze2
	)

	if ! use doc; then
		args+=(--docs=none)
	fi

	if ! use profile; then
		args+=(--flavour=quick)
	fi

	DESTDIR="${D}" ${S}/usr/bin/hadrian ${args[@]} || die

	# path to the package.cache
	local package_confdir="${ED}/usr/$(get_libdir)/${GHC_P}/lib/package.conf.d"
	PKGCACHE="${package_confdir}"/package.cache
	# copy the package.conf.d, including timestamp, save it so we can help
	# users that have a broken package.conf.d
	cp -pR "${package_confdir}"{,.initial} || die "failed to backup intial package.conf.d"

	# copy the package.conf, including timestamp, save it so we later can put it
	# back before uninstalling, or when upgrading.
	cp -p "${PKGCACHE}"{,.shipped} \
		|| die "failed to copy package.conf.d/package.cache"

	newbashcomp "${FILESDIR}"/ghc-bash-completion ghc-pkg
	newbashcomp utils/completion/ghc.bash         ghc

	local target="${CTARGET:-${CHOST}}"

	newenvd - "50${P}" <<-_EOF_
		LDPATH="${EPREFIX}/usr/lib/ghc-${PV}/lib/${target%%-*}-linux-ghc-${PV}"
	_EOF_
}

pkg_preinst() {
	# have we got an earlier version of ghc installed?
	if has_version "<${CATEGORY}/${PF}"; then
		haskell_updater_warn="1"
	fi
}

pkg_postinst() {
	ghc-reregister

	# path to the package.cache
	PKGCACHE="${EROOT}/usr/$(get_libdir)/${GHC_P}/lib/package.conf.d/package.cache"

	# give the cache a new timestamp, it must be as recent as
	# the package.conf.d directory.
	touch "${PKGCACHE}"

	if [[ "${haskell_updater_warn}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of GHC."
		ewarn "You may have to run"
		ewarn "      'haskell-updater'"
		ewarn "to rebuild all ghc-based Haskell libraries."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
	fi
}

pkg_prerm() {
	PKGCACHE="${EROOT}/usr/$(get_libdir)/${GHC_P}/lib/package.conf.d/package.cache"
	rm -rf "${PKGCACHE}"

	cp -p "${PKGCACHE}"{.shipped,}
}

pkg_postrm() {
	ghc-package_pkg_postrm
}
