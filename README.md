# MemLock: Memory Usage Guided Fuzzing

This repository provides the tool and the evaluation subjects for the paper "MemLock: Memory Usage Guided Fuzzing" accepted for the technical track at ICSE'2020. A pre-print of the paper can be found at [ICSE2020_MemLock.pdf](https://wcventure.github.io/pdf/ICSE2020_MemLock.pdf).

The repository contains three folders: [*tool*](#tool), [*tests*](#tests) and [*evaluation*](#evaluation).

## Tool

MemLock is built on top of the fuzzer AFL. Check out [AFL's website](http://lcamtuf.coredump.cx/afl/) for more information details. We provide here a snapshot of MemLock. For simplicity, we provide shell script for the whole installation.

### Requirements

- Strongly Recommended: Ubuntu 16.04 LTS
- Run the following command to install Docker:
  ```sh
  $ sudo apt-get install docker.io
  ```
  (If you have any question on docker, you can see [Docker's Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)).
- Run the following command to install required packages
    ```sh
    $ sudo apt-get install tmux git build-essential python3 cmake libtool automake autoconf autotools-dev m4 autopoint help2man bison flex texinfo zlib1g-dev libexpat1-dev libfreetype6 libfreetype6-dev
    ```

### Clone the Repository

```sh
$ git clone https://github.com/ICSE2020-MemLock/MemLock.git MemLock --depth=1
$ cd MemLock
```

### Build and Run the Docker Image

Firstly, system core dumps must be disabled as with AFL.

```sh
$ echo core|sudo tee /proc/sys/kernel/core_pattern
$ echo performance|sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

Run the following command to automatically build the docker image and configure the environment.

```sh
# disable ptrace_scope for PIN
$ echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope

# build docker image
$ sudo docker build -t memlock --no-cache ./

# run docker image
$ sudo docker run --cap-add=SYS_PTRACE -it memlock /bin/bash
```




## Tests

Before you use MemLock fuzzer, you need to first use two simple examples provided by us to determine whether the Memlock fuzzer can work normally. We show two simple examples to shows how MemLock can detect excessive memory consumption and why AFL cannot detect these bugs easily. Example 1 demonstrates an uncontrolled-recursion bug and Example 2 demonstrates an uncontrolled-memory-allocation bug.

### Run for testing example 1

Example 1 demonstrates an uncontrolled-recursion bug. The function `fact()` in `example1.c` is a recursive function. With a sufficiently large recursive depth, the execution would run out of stack memory, causing stack-overflow. You can perform fuzzing on this example program by following commands.

```sh
# enter the tests folder
$ cd tests

# run testing example 1 with MemLock
$ ./run_test1_MemLock.sh

# run testing example 1 with AFL (Open another terminal)
$ ./run_test1_AFL.sh
```

In our experiments for testing example 1, MemLock can find crashes in a few minutes while AFL can not find any crashes.

### Run for testing example 2

Example 2 demonstrates an uncontrolled-memory-allocation bug.  At line 25 in `example2.c`, the length of the user inputs is fed directly into `new []`. By carefully handcrafting the input, an adversary can provide arbitrarily large values, leading to program crash (i.e., `std::bad_alloc`) or running out of memory. You can perform fuzzing on this example program by following commands.

```sh
# enter the tests folder
$ cd tests

# run testing example 2 with MemLock
$ ./run_test2_MemLock.sh

# run testing example 2 with AFL (Open another terminal)
$ ./run_test2_AFL.sh
```

In our experiments for testing example 2, MemLock can find crashes in a few minutes while AFL can not find any crashes.


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
@inproceedings{Wen2020MemLock,
  title={MemLock: Memory Usage Guided Fuzzing},
  author={Wen, Cheng and Wang, Haijun and Li, Yuekang and Qin, Shengchao and Liu Yang, and Xu Zhiwu, and Chen, Hongxu and Xie, Xiaofei and Pu, Geguang and Liu Ting},
  booktitle={Proceedings of the 42nd International Conference on Software Engineering},
  year={2020}
}
```

## Links

- **Website**: https://icse2020-memlock.github.io/

- **GitHub**: https://github.com/ICSE2020-MemLock/MemLock

- **Benchmark**: https://github.com/ICSE2020-MemLock/MemLock_Benchmark