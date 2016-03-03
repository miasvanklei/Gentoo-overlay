# Gentoo repository for musl related patches.

This repository adds some ebuilds which are broken in portage when used with musl, or aren't provided at all.
some examples:
      - electron and atom: are based on chromium, binary builds use jmalloc which doesn't work with musl. even if it did work,
        chromium by default uses some obscure glibc functions.
      - an up-to-date llvm ebuild (3.8.0-rc3 at the moment, not yet released) which can be used standalone without gcc installed(linux kernel still needs gcc).
      - prolog ebuilds: swipl and yapl(yapl is heavily broken, outdated c++ code).
      - dlang ebuilds that can be used with musl, no segfaults.
      - rust ebuild with system llvm(1.7 released on march 3 with llvm 3.8 patch).
      - systemd ebuild with alot of patches. it works and runs but it isn't recommend to use for daily usage.
      
some extra patches are in the patches directory, you can create a symlink for all patches, or only for specific packages.
