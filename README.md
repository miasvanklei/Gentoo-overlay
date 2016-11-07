# Gentoo repository for musl related patches.

ld.lld from llvm is used as linker for all packages.

binutils is not installed, but some tools are still needed:
      - ld.bfd for the linux kernel because lld does not work yet
      - objcopy for the linux kernel because llvm lacks one
      - as for the linux kernel because clang checks emmitted assembly
      
gcc is not needed anymore, for all others clang is used with libcxx, libcxxabi, llvm-libunwind:
      - gentoo-sources (apply two patches)
      
lldb is used as debugger.

systemd(a lot of patches).

some other ebuilds:
      - electron and atom: are based on chromium, binary builds use jmalloc which doesn't work with musl. even if it did work,
        chromium by default uses some obscure glibc functions.
      - dlang ebuilds that can be used with musl, no segfaults.
      
alot extra patches are in the patches directory, you can create a symlink for all patches, or only for specific packages.
