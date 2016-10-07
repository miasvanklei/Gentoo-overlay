# Gentoo repository for musl related patches.

ld.lld from llvm is used as linker for all packages.
binutils is not installed, but some tools are still needed:
      - strip
      - ld.bfd for the linux kernel and sandbox
      - objcopy for the linux kernel
      - as for the linux kernel
      
gcc is only needed for two packages right now, for all others clang is used with libcxx, libcxxabi, llvm-libunwind:
      - gentoo-sources
      - gtk+ (investigating the issue)
      
lldb is used as debugger.

gnome 3.22 is included as well with systemd(alot of patches).

some other ebuilds:
      - electron and atom: are based on chromium, binary builds use jmalloc which doesn't work with musl. even if it did work,
        chromium by default uses some obscure glibc functions.
      - dlang ebuilds that can be used with musl, no segfaults.
      
alot extra patches are in the patches directory, you can create a symlink for all patches, or only for specific packages.
