# use the real gcc instead of the apple clang
# brew install gcc
export CC=gcc-13
export CXX=g++-13
# brew uninstall binutils
# Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+
# brew install gmp mpfr libmpc
JOBS=6
# generate with
# chage the jobs to the number of your cpu cores
# ./build-csky-gcc.py csky-gcc --src ./ --triple csky-unknown-elf --jobs=7 --fake

# put this script to the root of "toolchain_build" directory
TOOLCHAIN_BUILD_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
WITH_XX="--with-gmp=/opt/homebrew/Cellar/gmp/6.2.1_1 --with-mpfr=/opt/homebrew/Cellar/mpfr/4.1.0-p13 --with-mpc=/opt/homebrew/Cellar/libmpc/1.3.1"
mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-binutils
mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps
if [ ! -f $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_binutils ]; then
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-binutils && $TOOLCHAIN_BUILD_DIR/./binutils/configure --disable-werror --with-included-gettext --disable-gdb --target=csky-unknown-elf --prefix=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64 --with-sysroot=yes --enable-any $WITH_XX
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-binutils && make -j$JOBS && make install -j$JOBS
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Error: binutils build failed"
    exit $retVal
  fi
  touch $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_binutils
else
  echo "binutils already built"
fi

if [ ! -f $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gcc-stage1 ]; then
  mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage1
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage1 && $TOOLCHAIN_BUILD_DIR/./gcc/configure --enable-languages=c --target=csky-unknown-elf --prefix=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64 --without-headers --with-newlib --disable-shared --disable-libssp --disable-libgomp --disable-libmudflap --disable-threads --with-cskylibc=newlib --disable-libquadmath --disable-libatomic --with-sysroot=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64/csky-unknown-elf/libc --with-pkgversion="Xuantie-800 elf newlib gcc Toolchain None B-20230530" $WITH_XX
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage1 && make -j$JOBS && make install -j$JOBS
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Error: gcc-stage1 build failed"
    exit $retVal
  fi
  touch $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gcc-stage1
else
  echo "gcc-stage1 already built"
fi

export PATH=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64/bin:$PATH
if [ ! -f $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_newlib ]; then
  mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-newlib
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-newlib && $TOOLCHAIN_BUILD_DIR/./newlib/configure --target=csky-unknown-elf --enable-newlib-io-long-double --enable-newlib-io-long-long --enable-newlib-io-c99-formats --enable-newlib-retargetable-locking --prefix=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64 CFLAGS_FOR_TARGET="-g0 -O2" $WITH_XX
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-newlib && make -j$JOBS && make install -j$JOBS
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Error: newlib build failed"
    exit $retVal
  fi
  touch $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_newlib
else
  echo "newlib already built"
fi

if [ ! -f $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gcc-stage2 ]; then
  mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage2
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage2 && $TOOLCHAIN_BUILD_DIR/./gcc/configure --target=csky-unknown-elf --prefix=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64 --with-lib=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64/csky-unknown-elf/lib --with-pkgversion="Xuantie-800 elf newlib gcc Toolchain None B-20230530" --enable-sjlj-exceptions --disable-shared --disable-libssp --enable-languages=c,c++ --with-headers=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64/csky-unknown-elf/include --with-newlib --disable-threads $WITH_XX
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gcc-stage2 && make -j$JOBS && make install -j$JOBS
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Error: gcc-stage2 build failed"
    exit $retVal
  fi
  touch $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gcc-stage2
else
  echo "gcc-stage2 already built"
fi

# You might have to add `#undef DOT` to `gdb/split-name.h`
if [ ! -f $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gdb ]; then
  mkdir -p $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gdb
  # cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gdb && $TOOLCHAIN_BUILD_DIR/./gdb/configure --target=csky-unknown-elf --prefix=$TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/Xuantie-800-gcc-elf-newlib-x86_64 --disable-werror --disable-ld --disable-binutils --disable-gas --disable-gold --disable-gprof --without-auto-load-safe-path --with-libexpat-prefix= --with-python=no --disable-sim --enable-install-libbfd --with-pkgversion="Xuantie-800 elf newlib gcc Toolchain None B-20230530" $WITH_XX
  cd $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/build-gdb && make -j$JOBS && make install -j$JOBS
  retVal=$?
  if [ $retVal -ne 0 ]; then
    echo "Error: gdb build failed"
    exit $retVal
  fi
  touch $TOOLCHAIN_BUILD_DIR/build-gcc-csky-unknown-elf/build-Xuantie-800-gcc-elf-newlib-x86_64/stamps/.stamp_gdb
else
  echo "gdb already built"
fi