#!/bin/bash
set -e
cd "$(dirname "$0")"
source config
export PATH="$OUTPUT_DIR/bin:$PATH"

BUILD_DIR=".build-gcc"

(test -d $BUILD_DIR && rm -rf $BUILD_DIR) || true
mkdir -p $BUILD_DIR && cd $BUILD_DIR
SOURCE_TARBALL=gcc-$GCC_VERSION.tar.xz  
mkdir -p "$SOURCE_DIR"
if [ ! -f "$SOURCE_DIR/$SOURCE_TARBALL" ]; then
    curl -sSL "http://mirrors.ustc.edu.cn/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz" -o "$SOURCE_DIR/$SOURCE_TARBALL.tmp"
    mv "$SOURCE_DIR/$SOURCE_TARBALL.tmp" "$SOURCE_DIR/$SOURCE_TARBALL"
fi
tar xf "$SOURCE_DIR/$SOURCE_TARBALL" --strip 1
apply_patch gcc-$GCC_VERSION

# LDFLAGS may not work for libtool, append it to CC
export CPP="${HOST_CPP:-cpp}"
export CC="${HOST_CC:-cc} $HOST_LDFLAGS"
export CXX="${HOST_CXX:-c++} $HOST_LDFLAGS"
export CPPFLAGS="$HOST_CPPFLAGS"
export CFLAGS="$HOST_CFLAGS -O2 -fPIC"
export CXXFLAGS="$HOST_CXXFLAGS -std=c++11 -O2 -fPIC"
export LDFLAGS="$HOST_LDFLAGS"

for target in "${CROSS_TARGETS[@]}"; do
    export CPPFLAGS_FOR_TARGET="--sysroot ${OUTPUT_DIR}/$target"

    mkdir -p build-$target && cd build-$target
    ../configure $CONFIGURE_ARGS --target=$target --prefix="$OUTPUT_DIR" --disable-bootstrap --enable-version-specific-runtime-libs \
        --disable-multilib --enable-linker-build-id --enable-static --enable-shared --enable-shared-libgcc \
        --enable-languages=c,c++ --disable-symvers --disable-sjlj-exceptions --enable-__cxa_atexit --with-dwarf2 \
        --enable-threads=posix --enable-graphite --enable-libatomic --with-default-libstdcxx-abi=gcc4-compatible --enable-libstdcxx-filesystem-ts \
        --with-gnu-ld --with-gnu-as
    make -j$(cpu_count) all
    make -j$(cpu_count) install

    # Solve libgcc installing bug
    if [[ -d "$OUTPUT_DIR/lib/gcc/$target/lib" ]]; then
        mv "$OUTPUT_DIR/lib/gcc/$target/lib"/* "$OUTPUT_DIR/lib/gcc/$target/$GCC_VERSION/"
    fi
    
    cd ../
done

