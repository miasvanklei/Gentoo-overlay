# Gentoo ebuild repository with musl/clang related patches.

Note: This is a personal repository. Ebuilds may break at any time without notice. However I do try to prevent this from happening.

# Goal
To compile all packages on my gentoo system with clang and llvm tools (lld, integrated-as) and gcc + binutils removed:
 * kde plasma, snap, texlive, rust, ghc + haskell packages, R, firefox, libreoffice, dotnet core, mono

# Systems
 * Banana pi, rock64, pine h64, pinebook pro, amd threadripper 2n generation, intel 8th generation mobile

# Status (packages on my system)
 * arm64: all packages including linux kernel.
 * arm: all packages including linux kernel.
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
   * musl, glibc does not compile/work with clang and probably never will.

# Organization
 * portage: contains package.* for my system, probably only applies to me.
 * portage/patches: contains patches for fixing compilation of ebuilds in gentoo repo
 * gentoo.patch: contains some trivial patches for gentoo ebuilds themselves (change of dependencies, extra configure arguments).
