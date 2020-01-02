#!/bin/bash
BIN_PATH=$(readlink -f "$0")
ROOT_DIR=$(dirname $BIN_PATH)

echo core|sudo tee /proc/sys/kernel/core_pattern
echo performance|sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

${ROOT_DIR}/tool/install_llvm.sh
${ROOT_DIR}/tool/install_MemLock.sh
${ROOT_DIR}/evaluation/BUILD/build_cxxfilt.sh
${ROOT_DIR}/evaluation/FUZZ/run_MemLock_cxxfilt.sh
