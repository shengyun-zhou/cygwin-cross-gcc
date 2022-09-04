#!/bin/bash
set -e
cd "$(dirname "$0")"
PRE_PWD="$(pwd)"
cd ..
source config
check_build_for_targets 'cygwin' || exit 0
cd "$PRE_PWD"

declare -A CYGWIN_ARCH_MAP
CYGWIN_ARCH_MAP=(
    ["x86"]="i686-pc-cygwin"
    ["x86_64"]="x86_64-pc-cygwin"
)

for CYGWIN_ARCH in "${!CYGWIN_ARCH_MAP[@]}"; do
    CYGWIN_TARGET=${CYGWIN_ARCH_MAP[$CYGWIN_ARCH]}
    rm -rf .cygwin-sysroot-$CYGWIN_ARCH || true
    mkdir .cygwin-sysroot-$CYGWIN_ARCH && cd .cygwin-sysroot-$CYGWIN_ARCH
    curl -L "https://mirrors.ustc.edu.cn/cygwin/$CYGWIN_ARCH/release/cygwin/cygwin-devel/cygwin-devel-$CYGWIN_VERSION.tar.xz" -o cygwin-devel.tar.xz
    tar xf cygwin-devel.tar.xz
    curl -L "https://mirrors.ustc.edu.cn/cygwin/$CYGWIN_ARCH/release/w32api-headers/w32api-headers-$CYGWIN_W32API_VERSION.tar.xz" -o cygwin-w32api-headers.tar.xz
    tar xf cygwin-w32api-headers.tar.xz
    curl -L "https://mirrors.ustc.edu.cn/cygwin/$CYGWIN_ARCH/release/w32api-runtime/w32api-runtime-$CYGWIN_W32API_VERSION.tar.xz" -o cygwin-w32api-runtime.tar.xz
    tar xf cygwin-w32api-runtime.tar.xz
    mv usr/lib/w32api/* usr/lib && rm -rf usr/lib/w32api
    curl -L "https://mirrors.ustc.edu.cn/cygwin/$CYGWIN_ARCH/release/libiconv/libiconv-devel/libiconv-devel-$CYGWIN_LIBICONV_VERSION.tar.xz" -o cygwin-libiconv-devel.tar.xz
    tar xf cygwin-libiconv-devel.tar.xz
    tar cvzf ../cygwin-sysroot-${CYGWIN_VERSION}_${CYGWIN_ARCH}.tar.gz -C usr ./include ./lib
    cd ..
    rm -rf .cygwin-sysroot-$CYGWIN_ARCH
done
