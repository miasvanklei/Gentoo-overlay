# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-9999.ebuild,v 1.21 2015/05/13 17:37:06 ulm Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs multilib-minimal git-2

EGIT_REPO_URI="git://git.musl-libc.org/musl"

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="+compat +libunwind"

RDEPEND="!sys-apps/getent
	 libunwind? ( sys-libs/libunwind )
	 compat? ( sys-libs/bsd-compat
		   sys-libs/argp-standalone )"

src_prepare() {
	epatch "${FILESDIR}"/kernel.patch
	epatch "${FILESDIR}"/musl-add-gnu-symbols.patch
	epatch "${FILESDIR}"/printf.patch
	epatch "${FILESDIR}"/glibc-abi-compat.patch
	epatch "${FILESDIR}"/qsort_r.patch
	epatch "${FILESDIR}"/backtrace.patch
	epatch "${FILESDIR}"/ptrace.patch
	epatch "${FILESDIR}"/mallinfo.patch
	epatch "${FILESDIR}"/context.patch
	epatch "${FILESDIR}"/pthread-try-timed.patch
	epatch "${FILESDIR}"/no-utf8-code-units-locale.patch
	epatch "${FILESDIR}"/dmd-compat.patch
	epatch "${FILESDIR}"/musl-obstack.patch
        cp /usr/include/unwind.h "${S}"/src/internal
        cp /usr/include/__libunwind_config.h "${S}"/src/internal
	mkdir -p "${D}"/usr/bin || die
}

multilib_src_configure() {
	append-flags "-fPIC"
	ECONF_SOURCE="${S}" \
        econf \
	--prefix=/usr \
	--syslibdir=/$(get_libdir) \
	--libdir=/usr/$(get_libdir) \
	--disable-gcc-wrapper
}

multilib_src_compile() {
	emake || die
}

multilib_src_install() {

	MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bits/*
	)


	emake DESTDIR="${D}" install || die

	rm -r "${D}"/usr/include/libintl.h
	rm -r "${D}"/usr/include/iconv.h

	# musl provides ldd via a sym link to its ld.so
	local target=$(${CC} -dumpmachine)
	local arch
	case ${target} in
                x86_64*) arch="x86_64";;
                arm*)   arch="armhf";; # We only have hardfloat right now
               	mips*)  arch="mips${endian}";;
                ppc*)   arch="powerpc";;
                i?86*)   arch="i386";;
        esac

	mv -f "${D}"/usr/$(get_libdir)/libc.so "${D}"/$(get_libdir)/ld-musl-${arch}.so.1
	gen_usr_ldscript ld-musl-${arch}.so.1
	mv "${D}"/usr/$(get_libdir)/ld-musl-${arch}.so.1 "${D}"/usr/$(get_libdir)/libc.so

	if multilib_is_native_abi; then
		dosym /lib/ld-musl-${arch}.so.1 /usr/bin/ldd
		local i
        	for i in getconf getent ; do
                	${CC} ${CFLAGS} "${FILESDIR}"/$i.c -o "$D"/usr/bin/$i
        	done
	fi

	dosym /$(get_libdir)/ld-musl-${arch}.so.1 /usr/bin/${target}-ldd
}

pkg_postinst() {
	[ "${ROOT}" != "/" ] && return 0

	# reload init ...
	/sbin/telinit U 2>/dev/null
}
