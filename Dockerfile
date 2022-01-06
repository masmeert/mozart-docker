FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update
RUN apt-get install -y libboost-all-dev tk8.5-dev emacs subversion cmake git python libxml2-dev default-jre make

# Utilities
RUN git clone --branch release_39 https://github.com/llvm-mirror/llvm
WORKDIR /llvm/tools
RUN git clone --branch release_39 https://github.com/llvm-mirror/clang
WORKDIR /llvm
RUN mkdir build
WORKDIR /llvm/build
RUN ls
RUN cmake -DCMAKE_BUILD_TYPE=Release  \
        -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/../../llvm-install \
        ..
RUN make && make install

# Installing Mozart
WORKDIR /
RUN export PATH=`pwd`/llvm-install/bin:$PATH
RUN git clone --recursive https://github.com/mozart/mozart2
WORKDIR /mozart2
RUN mkdir build
WORKDIR /mozart2/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
RUN make install

RUN useradd -ms /bin/bash mozart
RUN echo mozart:mozart | chpasswd
RUN adduser mozart sudo
ENV PATH="$PATH:/usr/local/bin/oz:"
WORKDIR /home/mozart
ADD test.oz .
RUN chown mozart:mozart test.oz
USER mozart
CMD bash
