# Gentoo repository for musl related patches.

This repository adds some ebuilds which are broken in portage when used with musl, or aren't provided at all.
some examples:
      - electron and atom: are based on chromium, binary builds use jmalloc which doesn't work with musl. even if it did work,
        chromium by default uses some obscure glibc functions.
      - an up-to-date (3.9.0) llvm ebuild, which can be used standalone without gcc installed. kernel works but suspend is broken.
      - prolog ebuilds: swipl and yapl(yapl is heavily broken, outdated c++ code).
      - dlang ebuilds that can be used with musl, no segfaults.
      - rust ebuild with system llvm (1.10).
      - systemd ebuild with alot of patches. it works and runs but it isn't recommend to use for daily usage.
      
some extra patches are in the patches directory, you can create a symlink for all patches, or only for specific packages.
