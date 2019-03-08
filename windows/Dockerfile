FROM debian:buster-slim

LABEL maintainer "alxchk@gmail.com"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    WINEDEBUG="-all" \
    OPENSSL_VER=1.0.2r \
    BUILDENV=/build \
    WINE=${WINE:-wine} \
    WINE32="/build/win32" \
    WINE64="/build/win64" \
    DOWNLOADS="/build/downloads" \
    RC="/build/rc-with-includes" \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++

RUN dpkg --add-architecture i386 && apt-get update && apt-get upgrade -y && \
    apt-get -y install --no-install-recommends apt-utils \
    mingw-w64 g++-mingw-w64-x86-64 g++-mingw-w64-i686 \
    debootstrap python python-pip git make wine wine64 wine32 xvfb \
    python-setuptools-git build-essential python-dev python-wheel \
    xauth xxd zip unzip automake && apt-get clean

RUN mkdir -p $BUILDENV/workspace/project
RUN yes | pip install pylzma

COPY rc-with-includes $BUILDENV/rc-with-includes
COPY downloads $BUILDENV/downloads

COPY windows.sh $BUILDENV/

RUN \
	chmod +x /build/windows.sh && \
	/usr/bin/xvfb-run /build/windows.sh

RUN \
	cd $WINE32/drive_c/ && tar zxf $DOWNLOADS/openssl-$OPENSSL_VER.tar.gz && \
	mv openssl-$OPENSSL_VER openssl && cd $WINE32/drive_c/openssl && \
	WINEPREFIX=$WINE32 wine perl Configure VC-WIN32 --prefix=C:\\openssl-build \
         	no-comp no-srp enable-weak-ssl-ciphers && \
	WINEPREFIX=$WINE32 wine cmd /c ms\\do_ms.bat && \
	WINEPREFIX=$WINE32 wine cmd /c ms\\do_nasm.bat && \
	sed -i -e 's@/Zi@@g;s@/debug@@g' ms/nt.mak && \
	$WINE32/nmake.sh -f ms\\nt.mak && \
	$WINE32/nmake.sh -f ms\\nt.mak install && \
        rm -rf $WINE32/drive_c/openssl

RUN \
	cd $WINE32/drive_c/ && tar zxf $DOWNLOADS/openssl-$OPENSSL_VER.tar.gz && \
	mv openssl-$OPENSSL_VER openssl && cd $WINE32/drive_c/openssl && \
	WINEPREFIX=$WINE64 wine perl Configure VC-WIN64A --prefix=C:\\openssl-build \
         	no-comp no-srp enable-weak-ssl-ciphers && \
	WINEPREFIX=$WINE64 WINEPATH="C:\\nasm" wine cmd /c ms\\do_win64a.bat && \
	sed -i -e 's@/Zi@@g;s@/debug@@g' ms/nt.mak && \
	$WINE64/nmake.sh -f ms\\nt.mak && \
	$WINE64/nmake.sh -f ms\\nt.mak install && \
        rm -rf $WINE64/drive_c/openssl

RUN \
        for dir in $WINE32 $WINE64; do \
	ln -s $dir/drive_c/openssl-build/include/openssl \
	$dir/drive_c/Python27/include && \
        ln -s $dir/drive_c/openssl-build/lib/ssleay32.lib $dir/drive_c/Python27/libs/libssl.lib && \
	ln -s $dir/drive_c/openssl-build/lib/libeay32.lib $dir/drive_c/Python27/libs/libcrypto.lib; \
        done

COPY patches /build/patches

RUN \
	for dir in $WINE32 $WINE64; do \
	cd $dir/drive_c; patch --binary -p0 -i /build/patches/distutils.patch; done; \
	rm -rf /build/patches; \
	cp -vf $DOWNLOADS/stdint.h \
	"$WINE32/drive_c/Program Files/Common Files/Microsoft/Visual C++ for Python/9.0/VC/include/"; \
	cp -vf $DOWNLOADS/stdint.h \
	"$WINE64/drive_c/Program Files (x86)/Common Files/Microsoft/Visual C++ for Python/9.0/VC/include/"

RUN apt-get remove -y python-pip python-setuptools-git \
	build-essential python-dev python-wheel automake && \
	apt-get autoremove -y && apt-get clean && \
	rm -rf $DOWNLOADS $DOWNLOADS/windows.sh

# FROM scratch
# COPY --from=0 / /

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
