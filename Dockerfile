FROM debian:stable

# see also:
# https://github.com/X547/haiku/blob/device_manager2-r2/ReadMe.Compiling.md

RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    git \
    bison \
    flex \
    texi2html \
    autoconf \
    automake \
    gawk \
    nasm \
    wget \
    zip unzip \
    xorriso \
    mtools \
    python3 \
    libz-dev \
    libzstd-dev \
    u-boot-tools \
    attr
