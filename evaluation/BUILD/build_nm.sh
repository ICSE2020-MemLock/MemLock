#!/bin/bash

BIN_PATH=$(readlink -f "$0")
ROOT_DIR=$(dirname $(dirname $(dirname $BIN_PATH)))

if ! [ -d "${ROOT_DIR}/tool/MemLock/build/bin" ]; then
	${ROOT_DIR}/tool/install_MemLock.sh
fi

PATH_SAVE=$PATH
LD_SAVE=$LD_LIBRARY_PATH

export PATH=${ROOT_DIR}/clang+llvm/bin:$PATH
export LD_LIBRARY_PATH=${ROOT_DIR}/clang+llvm/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export AFL_PATH=${ROOT_DIR}/tool/MemLock

if ! [ $(command llvm-config --version) = "6.0.1" ]; then
	echo ""
	echo "You can simply run tool/build_MemLock.sh to build the environment."
	echo ""
	echo "Please set:"
	echo "export PATH=$PREFIX/clang+llvm/bin:\$PATH"
	echo "export LD_LIBRARY_PATH=$PREFIX/clang+llvm/lib:\$LD_LIBRARY_PATH"
elif ! [ -d "${ROOT_DIR}/clang+llvm"  ]; then
	echo ""
	echo "You can simply run tool/build_MemLock.sh to build the environment."
	echo ""
	echo "Please set:"
	echo "export PATH=$PREFIX/clang+llvm/bin:\$PATH"
	echo "export LD_LIBRARY_PATH=$PREFIX/clang+llvm/lib:\$LD_LIBRARY_PATH"
else
	echo "start ..."
	wget -c https://ftp.gnu.org/gnu/binutils/binutils-2.31.tar.gz
	tar -zxvf binutils-2.31.tar.gz -C $(dirname ${BIN_PATH})/nm/
	rm binutils-2.31.tar.gz
	rm -rf $(dirname ${BIN_PATH})/nm/SRC
	mv $(dirname ${BIN_PATH})/nm/binutils-2.31 $(dirname ${BIN_PATH})/nm/SRC

	cd $(dirname ${BIN_PATH})/nm/SRC
	make distclean
	if [ -d "$(dirname ${BIN_PATH})/nm/SRC/build"  ]; then
		rm -rf $(dirname ${BIN_PATH})/nm/SRC/build
	fi
	mkdir $(dirname ${BIN_PATH})/nm/SRC/build
	CC=${ROOT_DIR}/tool/MemLock/build/bin/memlock-stack-clang CXX=${ROOT_DIR}/tool/MemLock/build/bin/memlock-stack-clang++ CFLAGS="-g -O0 -fsanitize=address" CXXFLAGS="-g -O0 -fsanitize=address" ./configure --prefix=$(dirname ${BIN_PATH})/nm/SRC/build --disable-shared
	make
	make install

	export PATH=${PATH_SAVE}
	export LD_LIBRARY_PATH=${LD_SAVE}
fi
