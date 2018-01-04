FROM alxchk/linux32

LABEL maintainer "alxchk@gmail.com"

ENV \
    OPENSSL_VER=1.0.2n \
    ZLIB_VER=1.2.11    \
    SQLITE_VER=3210000 \
    SQLITE_YEAR=2017   \
    PYTHON_VER=2.7.14  \
    XZ_VER=5.2.3

ADD compat /usr/include/
RUN cat /usr/include/pthread-compat.h >>/usr/include/pthread.h

ENV \
    CFLAGS="-Os -fPIC -pipe -L/opt/static" \
    CXXFLAGS="-Os -fPIC -pipe" \
    LDFLAGS="-s -O1 -fPIC -L/opt/static" \
    MAKEOPTS="-j 2" \
    LC_ALL=C \
    TERM= \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin/:/

ADD downloads/make-3.82.tar.gz /usr/src/
RUN \
    cd /usr/src/make-3.82 && \
    ./configure && make && make install && \
    apt-get --force-yes -y remove make << /dev/null && \
    rm -rf /usr/src/make-3.82

ADD downloads/zlib-$ZLIB_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/zlib-$ZLIB_VER && \
    ./configure --prefix=/usr --static && make && make install && \
    rm -rf /usr/src/zlib-$ZLIB_VER

ADD downloads/xz-$XZ_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/xz-$XZ_VER && \
    ./configure --prefix=/usr && make && make install && \
    rm -rf /usr/src/xz-$XZ_VER

ADD downloads/pkg-config-0.29.1.tar.gz /usr/src/
RUN \
    cd /usr/src/pkg-config-0.29.1 && \
    ./configure --with-internal-glib --prefix=/usr && \
    make install && rm -rf /usr/src/pkg-config-0.29.1

ADD downloads/libffi_3.2.1.orig.tar.gz /usr/src/
RUN \
    cd /usr/src/libffi-3.2.1 && \
    ./configure --enable-static --prefix=/usr && \
    make install && rm -rf /usr/src/libffi-3.2.1

ADD downloads/sqlite-autoconf-$SQLITE_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/sqlite-autoconf-$SQLITE_VER && \
    ./configure --prefix=/usr --disable-static-shell \
	--disable-dynamic-extensions && \
    make && make install && rm -rf /usr/src/sqlite-autoconf-$SQLITE_VER

ADD downloads/openssl-$OPENSSL_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/openssl-$OPENSSL_VER/ && \
    CC="gcc -Os -fPIC" ./Configure --prefix=/usr no-hw-xxx shared \
        no-dso no-err no-krb5 no-hw no-asm no-ssl2 linux-generic32 && \
    make depend >/dev/null 2>/dev/null && \
    make && make install ; \
    cp libssl.so.1.0.0 /usr/lib/libssl.so && \
    cp libcrypto.so.1.0.0  /usr/lib/libcrypto.so && \
    mkdir -p /usr/lib/pkgconfig/ && \
    cp *.pc /usr/lib/pkgconfig/ && \
    cd /usr/lib && \
    ldconfig -n . && \
    ln -s /usr/lib/libssl.so /usr/lib/libssl.so.1 && \
    ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.1 && \
    rm -rf /usr/src/openssl-$OPENSSL_VER

ADD downloads/Python-$PYTHON_VER.tgz /usr/src/
RUN \
    cd /usr/src/Python-$PYTHON_VER && \
    ./configure --prefix=/usr \
      --without-doc-strings --without-tsc \
      --with-fpectl --with-ensurepip=install --with-signal-module \
      --enable-ipv6 --enable-shared --enable-unicode=ucs4 && \
    make && make install && rm -rf /usr/src/Python-$PYTHON_VER

ADD downloads/glib-2.32.4.tar.xz /usr/src/
RUN \
    cd /usr/src/glib-2.32.4 && \
    CFLAGS="$CFLAGS -DPR_SET_NAME=15 -DPR_GET_NAME=16" ./configure \
        --prefix=/usr --disable-xattr --disable-fam --disable-selinux \
        --enable-static && \
    make -k ; make -k install ; rm -rf /usr/src/glib-2.32.4

ADD downloads/dbus-1.2.12.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-1.2.12 && ./configure --prefix=/usr \
        --disable-selinux --disable-libaudit \
        --disable-dnotify --disable-inotify --disable-kqueue \
        --disable-userdb-cache --enable-abstract-sockets && \
    make && make install && rm -rf /usr/src/dbus-1.2.12

ADD downloads/dbus-glib-0.88.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-glib-0.88 && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/dbus-glib-0.88

ADD downloads/dbus-python-0.84.0.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-python-0.84.0 && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/dbus-python-0.84.0

ADD downloads/gobject-introspection-1.32.1.tar.xz /usr/src/
RUN \
    cd /usr/src/gobject-introspection-1.32.1 && \
    CFLAGS="$CFLAGS -D_GNU_SOURCE" \
        ./configure --prefix=/usr --disable-tests && make && \
    make install && rm -rf /usr/src/gobject-introspection-1.32.1

ADD downloads/pygobject-3.2.2.tar.xz /usr/src/
RUN \
    cd /usr/src/pygobject-3.2.2 && CFLAGS="$CFLAGS -D_GNU_SOURCE" ./configure --disable-glibtest \
	--disable-cairo --prefix=/usr --enable-static && make -k ; \
    [ -f ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0.0.0 ] && \
    rm -f ./gi/_glib/.libs/libpyglib-gi-2.0-python.so{,.0,.0.0.0} && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0 && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0.0.0 && \
    rm -f ./gi/_gi.la ./gi/_gobject/_gobject.la ./gi/_glib/_glib.la && \
    rm -f ./gi/.libs/_gi.la ./gi/_gobject/.libs/_gobject.la ./gi/_glib/.libs/_glib.la && \
    make -k ; make install; rm -rf /usr/src/pygobject-3.2.2

ADD downloads/m4-1.4.18.tar.gz /usr/src/
RUN \
    cd /usr/src/m4-1.4.18 && \
    ./configure --prefix=/usr && make && make install && \
    rm -rf /usr/src/m4-1.4.18

ADD downloads/autoconf-2.69.tar.gz /usr/src/
RUN \
    cd /usr/src/autoconf-2.69 && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/autoconf-2.69

ADD downloads/automake-1.15.tar.gz /usr/src/
RUN \
    cd /usr/src/automake-1.15 && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/automake-1.15

RUN \
    rm -rf /usr/share/locale /usr/share/man /usr/share/info

RUN \
    cd /usr/lib/python2.7 && rm -rf test lib2to3 && \
    find -name "*.py" | python -m compileall -qfi - && \
    find -name "*.py" | python -OO -m compileall -qfi - && \
    find -name "*.so" | while read f; do strip $f; done && \
    rm -rf /usr/src && \
    apt-get clean

RUN mkdir -p /build/workspace/project

FROM scratch
COPY --from=0 / /

ENV \
    CFLAGS="-Os -fPIC -pipe -L/opt/static" \
    CXXFLAGS="-Os -fPIC -pipe" \
    LDFLAGS="-s -O1 -fPIC -L/opt/static" \
    LC_ALL=C \
    TERM= \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/usr/bin:/usr/sbin:/bin:/sbin:/build/workspace/project:/build/workspace/.local/bin \
    WORKSPACE=/build/workspace \
    PROJECT=/build/workspace/project \
    TOOLCHAIN_ARCH=x86

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with python and ancient 32bit ABI"
