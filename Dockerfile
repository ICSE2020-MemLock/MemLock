FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y git build-essential sudo

RUN mkdir -p /workdir/MemLock

WORKDIR /workdir/MemLock
COPY . /workdir/MemLock

RUN ./setup.sh