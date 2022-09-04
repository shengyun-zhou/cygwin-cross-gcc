#!/bin/bash
set -e
cd "$(dirname "$0")"

./install-prebuilt-stuff.sh
./build-gnu-binutils.sh
./build-gcc.sh
