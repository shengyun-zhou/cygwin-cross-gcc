## cross-cygwin-gcc

Cross toolchain to build Cygwin programs on non-Win32 platforms.

### Prerequisite development libs

| Lib     | CentOS       | Ubuntu/Debian   |
| ------- | ------------ | --------------- |
| libgmp  | gmp-devel    | libgmp-dev      |
| libmpfr | mpfr-devel   | libmpfr-dev     |
| libmpc  | libmpc-devel | libmpc-dev      |
| libisl  | isl-dev   | libisl-dev      |
 
### Build

1. Modify all component versions in the file `version`.

2. Prepare the prebuilt sysroot(libc, etc)

```shell
./prebuilt-cygwin/prepare_sysroot.sh
```

3. Start building all components

```shell
./build-all.sh
```

    The built toolchain will be output in the `output` directory.


