FROM debian:stretch-slim

LABEL maintainer "alxchk@gmail.com"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    WINEDEBUG="-all" \
    PYVER=2.7.14 \
    BUILDENV=/build \
    WINE=${WINE:-wine} \
    WINE32="$BUILDENV/win32" \
    WINE64="$BUILDENV/win64" \
    DOWNLOADS="$BUILDENV/downloads" \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++

RUN dpkg --add-architecture i386 && apt-get update && apt-get upgrade -y && \
    apt-get -y install --no-install-recommends apt-utils \
    mingw-w64 g++-mingw-w64-x86-64 g++-mingw-w64-i686 \
    debootstrap python python-pip git make wine wine64 wine32 xvfb \
    python-setuptools-git build-essential python-dev python-wheel \
    xauth xxd zip unzip && apt-get clean

RUN \
    mkdir -p \
          /build/downloads \
          /build/win32 \
          /build/win64 \
          /build/bootstrap

COPY windows.sh /build/bootstrap/

RUN \
    mkdir -p /build/workspace/project && \
    chmod +x /build/bootstrap/windows.sh

COPY downloads/* /build/downloads/
RUN yes | pip install pylzma

RUN /usr/bin/xvfb-run /build/bootstrap/windows.sh

RUN apt-get remove python-pip python-setuptools-git \
    build-essential python-dev python-wheel; apt-get clean; apt-get autoremove; \
    rm -rf /build/bootstrap /build/downloads

FROM scratch
COPY --from=0 / /

ENV \
    WINE32=/build/win32 \
    WINE64=/build/win64 \
    PYTHON32=/build/win32/python.sh \
    PYTHON64=/build/win64/python.sh \
    CL32=/build/win32/cl.sh \
    CL64=/build/win64/cl.sh \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++ \
    WINEDEBUG="-all" \
    PATH=/usr/bin:/usr/sbin:/bin:/sbin:/build/workspace/project:/build/workspace/.local/bin \
    WORKSPACE=/build/workspace \
    PROJECT=/build/workspace/project

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with wine (32/64) MSVC CL(Python) and MinGW"
