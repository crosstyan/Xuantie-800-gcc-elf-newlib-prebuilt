# c-sky toolchains built by Crosstyan

You could find x86_64-linux-gnu, mingw, even i686-linux-gnu toolchains in [upstream](https://occ.t-head.cn/community/download?id=3885366095506644992) (See also [this AUR](https://aur.archlinux.org/packages/csky-toolchain-bin))
However, I could not find any prebuilt for `aarch64-linux-gnu` (Arm64 Linux) and `apple-aarch64-darwin` (Arm64 macOS i.e. M1/M2 series) anywhere on the Internet. So I built them by myself.

You could find the prebuilt toolchains in [releases]().

## How to build

If you want to build the toolchains by yourself, here are some tips.

### Linux

Pretty straightforward. Just follow [c-sky/toolchain-build](https://github.com/c-sky/toolchain-build) make sure you have enough disk space (at least 80GB) and RAM (at least 8GB).

```bash
git clone https://github.com/c-sky/toolchain-build --recursive --depth=1
# if you miss the --recursive flag
# git submodule update --init
sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
# I would say you should use jobs=$(nproc)-2 if you don't want your computer to freeze
# especially when you are using a desktop environment
./build-csky-gcc.py csky-gcc --src ./ --triple csky-unknown-elf --jobs=-1
```

When the build is done, you could find the toolchains in `build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64`. The build script just assumed you are using `x86_64` and don't even bother to check your actual architecture. It's just a name anyway.

### macOS

You would have to do some modifications to the build script, luckily it has `--fake` flag.

```bash
# redirect the output to `build.sh`
./build-csky-gcc.py csky-gcc --src ./ --triple csky-unknown-elf --jobs=-1 --fake >> build.sh
```

Then you should modify the `build.sh` like my [build.sh](build.sh) or
just copy my [build.sh](build.sh).

A few dependencies are required though.

```bash
# use the real gcc instead of the apple clang
# brew install gcc
export CC=gcc-13
export CXX=g++-13

# if binutils from homebrew is installed, uninstall it
brew uninstall binutils

# Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+
brew install gmp mpfr libmpc
```

Run the `build.sh` with `./build.sh` and wait for a few hours.
