#!/bin/bash
set -e
cd "$(dirname "$0")"
source config

# Install prebuilt libc
for target in "${CROSS_TARGETS[@]}"; do
    arch=''
    case "$target" in
    i*86*-cygwin) sysroot_tar=prebuilt-cygwin/cygwin-sysroot-${CYGWIN_VERSION}_x86.tar.gz ;;
    x86_64*-cygwin) sysroot_tar=prebuilt-cygwin/cygwin-sysroot-${CYGWIN_VERSION}_x86_64.tar.gz ;;
    esac
    sysroot_dir="$OUTPUT_DIR/$target/usr"
    mkdir -p "$sysroot_dir"
    tar xf $sysroot_tar -C "$sysroot_dir" --strip 1
    ln -sfn usr/include "$OUTPUT_DIR/$target/include"
    ln -sfn usr/lib "$OUTPUT_DIR/$target/lib"
done
