# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common files shared between multiple slots of flang"
HOMEPAGE="https://llvm.org/"

S="${WORKDIR}"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="default-compiler-rt default-libcxx llvm-libunwind"

PDEPEND="
	sys-devel/clang:*
	default-compiler-rt? (
		sys-devel/clang-runtime[compiler-rt]
		llvm-libunwind? ( sys-libs/llvm-libunwind[static-libs] )
		!llvm-libunwind? ( sys-libs/libunwind[static-libs] )
	)
	!default-compiler-rt? ( sys-devel/gcc )
	default-libcxx? ( >=sys-libs/libcxx-${PV}[static-libs] )
"

pkg_pretend() {
	[[ ${CLANG_IGNORE_DEFAULT_RUNTIMES} ]] && return

	local flag missing_flags=()
	if ! use "default-compiler-rt" && has_version "sys-devel/clang[default-compiler-rt]"; then
		missing_flags+=( "${flag}" )
	fi

	if [[ ${missing_flags[@]} ]]; then
		eerror "It seems that you have the following flags set on sys-devel/clang:"
		eerror
		eerror "  ${missing_flags[*]}"
		eerror
		eerror "The default runtimes are now set via flags on sys-devel/clang-common."
		eerror "The build is being aborted to prevent breakage.  Please either set"
		eerror "the respective flags on this ebuild, e.g.:"
		eerror
		eerror "  sys-devel/clang-common ${missing_flags[*]}"
		eerror
		eerror "or build with CLANG_IGNORE_DEFAULT_RUNTIMES=1."
		die "Mismatched defaults detected between sys-devel/clang and sys-devel/clang-common"
	fi
}

src_install() {
	insinto /etc/clang
	newins - flang.cfg <<-EOF
		# This file is initially generated by sys-devel/clang-runtime.
		# It is used to control the default runtimes using by clang.

		--rtlib=$(usex default-compiler-rt compiler-rt libgcc)
		--unwindlib=$(usex default-compiler-rt libunwind libgcc)
		$(usex default-libcxx -lc++)
	EOF
}