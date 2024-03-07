# Gentoo ebuild repository with musl/clang related patches.

Note: This is a personal repository. Ebuilds may break at any time without notice. However I do try to prevent this from happening.

# Goal
To compile all packages on my gentoo system with clang and llvm tools and gcc + binutils removed:
 * kde plasma, texlive, rust, ghc + haskell packages, R, firefox, libreoffice, dotnet core

# Systems
 * Pine H64, OrangePi 5 plus, Tablet Qualcomm SQ3, AMD 2920x

# Status (packages on my system)
 * arm64: all packages including linux kernel.
 * x86_64: all packages including linux kernel.

# Toolchain
 * c/c++ compiler: clang
 * linker: lld
 * c++
   * libc++ is used as replacement for libstdc++
   * libc++abi is used as replacement for libsupc++
 * unwinder + builtins: gcc_s = llvm-libunwind + compiler-rt
   * llvm-libunwind is used as replacement for libgcc_eh (unwinder)
   * compiler-rt is used as replacement for libgcc (lowlevel builtins)
 * c library
   * musl

# Organization
 * portage: contains package.* for my system, probably only applies to me.
 * portage/patches: contains patches for fixing compilation of ebuilds in gentoo repo
