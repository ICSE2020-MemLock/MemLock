BIN_PATH=$(readlink -f "$0")
ROOT_DIR=$(dirname ${BIN_PATH})

if [ -d "${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1" ]; then
	rm -rf ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1
fi
git clone https://github.com/ICSE2020-MemLock/LLVMlib_asan.git ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1
tar -zxvf ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1/libclang_rt.asan-x86_64.tar.gz -C ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1
cp -rf ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1/* ${PREFIX}/clang+llvm/ua_asan/lib/clang/6.0.1/lib/linux/
rm -rf ${ROOT_DIR}/tool/MemLock/LLVMlib_asan_6.0.1/
