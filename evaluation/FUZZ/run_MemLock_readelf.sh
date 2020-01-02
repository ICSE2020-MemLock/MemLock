#!/bin/bash

BIN_PATH=$(readlink -f "$0")
ROOT_DIR=$(dirname $(dirname $(dirname $BIN_PATH)))

if ! [ -d "${ROOT_DIR}/tool/MemLock/build/bin" ]; then
	${ROOT_DIR}/tool/install_MemLock.sh
fi

export PATH=${ROOT_DIR}/clang+llvm/ua_asan/bin:$PATH
export LD_LIBRARY_PATH=${ROOT_DIR}/clang+llvm/ua_asan/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export AFL_PATH=${ROOT_DIR}/tool/MemLock

if ! [ $(command llvm-config --version) = "6.0.1" ]; then
	echo ""
	echo "You can simply run tool/build_MemLock.sh to build the environment."
	echo ""
	echo "Please set:"
	echo "export PATH=$PREFIX/clang+llvm/bin:\$PATH"
	echo "export LD_LIBRARY_PATH=$PREFIX/clang+llvm/lib:\$LD_LIBRARY_PATH"
elif ! [ -d "${ROOT_DIR}/clang+llvm/ua_asan/bin"  ]; then
	echo ""
	echo "You can simply run tool/build_MemLock.sh to build the environment."
	echo ""
	echo "Please set:"
	echo "export PATH=$PREFIX/clang+llvm/ua_asan/bin:\$PATH"
	echo "export LD_LIBRARY_PATH=$PREFIX/clang+llvm/ua_asan/lib:\$LD_LIBRARY_PATH"
else
	if ! [ -d "${ROOT_DIR}/evaluation/BUILD/readelf/SRC_MemLock/build/bin" ]; then
		${ROOT_DIR}/evaluation/BUILD/build_readelf.sh
	fi
	echo "start ..."
	cd ${ROOT_DIR}/evaluation/FUZZ
	if ! [ -d "${ROOT_DIR}/evaluation/FUZZ/readelf" ]; then
		mkdir readelf
	fi
	cd readelf
	i=0
	for ((i=1; i<100; i++))
	do
		if ! [ -d "${ROOT_DIR}/evaluation/FUZZ/readelf/out_MemLock$i" ]; then
			break
		fi
	done
	export ASAN_OPTIONS=detect_odr_violation=0:allocator_may_return_null=0:abort_on_error=1:symbolize=0:detect_leaks=0
	${ROOT_DIR}/tool/MemLock/build/bin/memlock-stack-fuzz -i ${ROOT_DIR}/evaluation/BUILD/cxxfilt/SEED/ -o out_MemLock$i -m none -d --  ${ROOT_DIR}/evaluation/BUILD/readelf/SRC_MemLock/build/bin/readelf -a @@
fi
