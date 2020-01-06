# MemLock: Memory Usage Guided Fuzzing

- **Website**: https://icse2020-memlock.github.io/

- **GitHub**: https://github.com/ICSE2020-MemLock/MemLock

- **Benchmark**: https://github.com/ICSE2020-MemLock/MemLock_Benchmark

This repository provides the tool and the evaluation subjects for the paper "MemLock: Memory Usage Guided Fuzzing" accepted for the technical track at ICSE'2020. A pre-print of the paper can be found at [ICSE2020_MemLock.pdf](https://wcventure.github.io/pdf/ICSE2020_MemLock.pdf).

The repository contains three folders: [*tool*](#tool), [*tests*](#tests) and [*evaluation*](#evaluation).

## Tool

MemLock is built on top of the fuzzer AFL. Check out [AFL's website](http://lcamtuf.coredump.cx/afl/) for more information details. We provide here a snapshot of MemLock. For simplicity, we provide shell script for the whole installation. And we recommend that you use [docker image](#installation-using-docker) to build MemLock.

### Requirements

- Recommended: Ubuntu 16.04 LTS
- Tmux, Git, Build-Essentials, Python3, Cmake, Libtool, Automake, Autoconf, Autotools, M4, Autopoint, Help2man, Bison, Flex: run 
    ```shell
    sudo apt install tmux git build-essential python3 cmake libtool autoamke autoconf autotools-dev m4 autopoint help2man bison flex
    ```
- Docker: see [Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/).
- clang+LLVM 6.0.1: run ` ./tool/install_llvm.sh`

### Clone the Repository

```sh
git clone https://github.com/ICSE2020-MemLock/MemLock.git MemLock --depth=1
cd MemLock
```

### Installation using Docker

We recommend that you perform the installation using Docker. This will save you a lot of time to configure the environment.

```sh
# disable ptrace_scope for PIN
$ echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope

# build docker image
$ sudo docker build -t memlock ./

# run docker image
$ sudo docker run --cap-add=SYS_PTRACE -it memlock /bin/bash
```

## Tests

As with AFL, system core dumps must be disabled.

```sh
$ sudo su
$ echo core >/proc/sys/kernel/core_pattern
$ cd /sys/devices/system/cpu
$ echo performance | tee cpu*/cpufreq/scaling_governor
$ exit
```

### Run for testing example 1

In our experiments for testing example 1, MemLock can find crashes in a few minutes while AFL can not find any crashes.

```sh
# enter the tests folder
$ cd tests

# run testing example 1 with MemLock
$ run_test1_MemLock.sh

# run testing example 1 with AFL (Open another terminal)
$ run_test1_AFL.sh
```

### Run for testing example 2

In our experiments for testing example 2, MemLock can find crashes in a few minutes while AFL can not find any crashes.

```sh
# enter the tests folder
$ cd tests

# run testing example 2 with MemLock
$ run_test2_MemLock.sh

# run testing example 2 with AFL (Open another terminal)
$ run_test2_AFL.sh
```

## Evaluation

The fold *evaluation* contains all our evaluation subjects. After having MemLock installed, you can run the script to build and instrument the subjects. After instrument the subjects you can run the script to perform fuzzing on the subjects.

### Build Target Program

In BUILD folder, You can run the script `./build_xxx.sh`. It shows how to build and instrument the subject. For example:

```sh
# build cxxfilt
$ cd BUILD
$ ./build_cxxfilt.sh
```

### Run for Fuzzing

After instrumenting the subjects, In FUZZ folder you can run the script `./run_MemLock_cxxfilt.sh` to run a MemLock fuzzer instance on program *cxxfilt*. If you want to compare its performance with AFL, you can open another terminal and run the script `./run_AFL_cxxfilt.sh`.

```sh
# build cxxfilt
$ cd FUZZ
$ ./run_MemLock_cxxfilt.sh
```

## Publications
```
MemLock: Memory Usage Guided Fuzzing. IEEE/ACM 42nd International Conference on Software Engineering, Seoul, South Korea, 23-29 May 2020.

@inproceedings{Wen2020MemLock,
  title={MemLock: Memory Usage Guided Fuzzing},
  author={Wen, Cheng and Wang, Haijun and Li, Yuekang and Qin, Shengchao and Liu Yang, and Xu Zhiwu, and Chen, Hongxu and Xie, Xiaofei and Pu, Geguang and Liu Ting},
  booktitle={Proceedings of the 42nd International Conference on Software Engineering, ICSE, Seoul, South Korea},
  year={2020}
}
```
