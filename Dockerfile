FROM ubuntu:16.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -i s:/archive.ubuntu.com:/mirrors.tuna.tsinghua.edu.cn/ubuntu:g /etc/apt/sources.list
RUN apt-get clean
RUN apt-get update --fix-missing
RUN apt-get install -y wget git build-essential cmake automake autoconf autotools-dev sudo --fix-missing

RUN mkdir -p /workdir/MemLock

WORKDIR /workdir/MemLock
COPY . /workdir/MemLock

RUN ./setup.sh
