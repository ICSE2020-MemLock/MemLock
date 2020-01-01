FROM ubuntu:16.04

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean
RUN apt-get update
RUN apt-get install -y git build-essential sudo --fix-missing

RUN mkdir -p /workdir/MemLock

WORKDIR /workdir/MemLock
COPY . /workdir/MemLock

RUN ./setup.sh