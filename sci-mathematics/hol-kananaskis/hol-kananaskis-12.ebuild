# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit elisp-common eutils

MY_PN="kananaskis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HOL4 interactive proof assistant for higher order logic"
HOMEPAGE=" https://hol-theorem-prover.org"
SRC_URI="https://github.com/HOL-Theorem-Prover/HOL/releases/download/${MY_P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs examples"

DEPEND=">=dev-lang/polyml-5.4.1:=[-portable]"

RDEPEND="doc? (
		virtual/latex-base
	)
	emacs? (
		virtual/emacs
	)
	${DEPEND}"

S="${WORKDIR}"/hol-kananaskis-${PV}
TARGETDIR="/usr/share/hol-kananaskis-"${PV}

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	cat <<- EOF >> "${S}/tools-poly/poly-includes.ML"
		val holdir = "${TARGETDIR}"
	EOF
	local flags="${LDFLAGS} -Wa,--noexecstack -Wl,-nopie"

	sed -e "s@val machine_flags = \[\]@val machine_flags = [${flags}]@" \
		-i "${S}/tools-poly/configure.sml" \
		|| die "Could not set flags in ${S}/tools-poly/configure.sml"
	sed -e "s@CFLAGS    = @CFLAGS    = ${CXXFLAGS} @" \
		-e 's@$(CXX) $(COBJS)@$(CXX) $(COBJS) '"${LDFLAGS}"'@' \
		-i "${S}/src/HolSat/sat_solvers/minisat/Makefile" \
		|| die "Could not set flags in ${S}/src/HolSat/sat_solvers/minisat/Makefile"
	sed -e "s@g++ -O3 Proof.o File.o zc2hs.cpp -o zc2hs@${CXX} ${CXXFLAGS} ${LDFLAGS} Proof.o File.o zc2hs.cpp -o zc2hs@" \
		-i "${S}/src/HolSat/sat_solvers/zc2hs/Makefile" \
		|| die "Could not set flags in ${S}/src/HolSat/sat_solvers/zc2hs/Makefile"
	eapply "${FILESDIR}"/c++11.patch
	eapply_user
}

src_configure() {
	poly < tools/smart-configure.sml || die "hol4 configure failed"
}

src_compile() {
	"${S}"/bin/build || die "hol4 build failed"
	# pushd "${S}/src/HolSat/sat_solvers/minisat" \
	# || die "Could not cd to ${S}/src/HolSat/sat_solvers/minisat"
	# emake
	# popd
	if use emacs ; then
		pushd "${S}/tools" || die "Could change directory to tools"
		elisp-compile *.el || die "emacs elisp compile failed"
		popd
		if use doc; then
			pushd "${S}/doc/hol-mode" \
				|| die "Could change directory to doc/hol-mode"
			emake || die "Could not make hol-mode docs"
			popd
		fi
	fi
	if use doc; then
		"${S}"/bin/build help || die "hol4 build help failed"
	fi
}

src_install() {
	# After building it there 1000s of files with the hard coded ${S}
	# directory in them.  This just fixes up the text files.  There are
	# still binary files with the hard coded ${S} directory in them.
	sed -e "s@${S}@${EPREFIX}${TARGETDIR}@g" \
		-i bin/hol -i bin/hol.bare \
		|| die "Could not fix directories in HOL scripts"
	find . -type f -regextype posix-egrep \
		-regex '.*/.*[.](sml|html|ui|uo|el|vim)' \
		-exec sed -e "s@${S}@${EPREFIX}${TARGETDIR}@g" -i {} \; \
		|| die "Could not fix directories in .sml .html .ui .uo .el .vim files"
	exeinto /usr/bin
	doexe bin/hol
	doexe bin/hol.bare
	doexe bin/Holmake

	exeinto "${TARGETDIR}/bin"
	doexe bin/build
	doexe bin/heapname
	doexe bin/mkmunge.exe
	doexe bin/unquote

	insinto "${TARGETDIR}"
	doins std.prelude
	doins -r src
	doins -r tools
	doins -r tools-poly

	if use examples; then
		doins -r examples
	fi

	if use doc; then
		doins -r help
		dohtml doc/*.html
		dodoc -r doc/athabasca
		dodoc -r doc/taupo
		dodoc COPYRIGHT INSTALL README
	fi

	if use emacs; then
		elisp-install "${PN}" tools/*.{el,elc}
		cp "${FILESDIR}/${SITEFILE}" "${S}"
		sed -e "s@/usr/bin/hol@${EPREFIX}/usr/bin/hol@" -i "${SITEFILE}" \
			|| die "Could not set hol executable path in emacs site file"
		elisp-site-file-install "${SITEFILE}"
		dodoc doc/hol-mode/{hol-mode.pdf,hol-mode.ps} \
			|| die "Could not install hol-mode docs"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		ewarn "For emacs hol-mode, insert the following line into ~/.emacs"
		ewarn ""
		ewarn '(load "hol-mode")'
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

