FROM alxchk/linux32

LABEL maintainer "alxchk@gmail.com"

ADD compat /usr/include/
RUN cat /usr/include/pthread-compat.h >>/usr/include/pthread.h

ENV \
    CFLAGS="-Os -DNDEBUG -fPIC -pipe -L/opt/static" \
    CXXFLAGS="-Os -DNDEBUG -fPIC -pipe" \
    LDFLAGS="-s -O1 -fPIC -L/opt/static" \
    MAKEOPTS="-j 2" \
    LC_ALL=C \
    TERM= \
    DEBIAN_FRONTEND=noninteractive \
    PYTHON_ABI_MODE="shared" \
    PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin/:/

ADD downloads/make-3.82.tar.gz /usr/src/
RUN \
    cd /usr/src/make-3.82 && \
    ./configure && make && make install && \
    apt-get --force-yes -y remove make << /dev/null && \
    rm -rf /usr/src/make-3.82

ENV ZLIB_VER=1.2.11
ADD downloads/zlib-$ZLIB_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/zlib-$ZLIB_VER && \
    ./configure --prefix=/usr --static && make && make install && \
    rm -rf /usr/src/zlib-$ZLIB_VER

ENV BZIP_VER=1.0.6
ADD downloads/bzip2_$BZIP_VER.orig.tar.bz2 /usr/src/
RUN \
    cd /usr/src/bzip2-$BZIP_VER && \
    make CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" && make PREFIX=/usr install && \
    rm -rf /usr/src/bzip2-$BZIP_VER

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

ENV SQLITE_VER=3280000
ADD downloads/sqlite-autoconf-$SQLITE_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/sqlite-autoconf-$SQLITE_VER && \
    ./configure --prefix=/usr --disable-static-shell \
	--disable-dynamic-extensions && \
    make && make install && rm -rf /usr/src/sqlite-autoconf-$SQLITE_VER

ENV OPENSSL_VER=1.0.2r
ADD downloads/openssl-$OPENSSL_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/openssl-$OPENSSL_VER/ && \
    CC="gcc -Os -fPIC" ./Configure --prefix=/usr no-hw-xxx shared \
        no-dso no-err no-krb5 no-hw no-ssl2 enable-weak-ssl-ciphers linux-generic32 && \
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

ADD downloads/attr-2.4.48.tar.gz /usr/src
RUN \
    cd /usr/src/attr-2.4.48 && ./configure --prefix=/usr --enable-static \
	--disable-shared && make && make install && rm -rf /usr/src/attr-2.4.48

ADD downloads/acl-2.2.53.tar.gz /usr/src
RUN \
    cd /usr/src/acl-2.2.53 && ./configure --prefix=/usr --enable-static \
	--disable-shared \
	ac_cv_lib_attr_getxattr=yes \
	&& make && make install && rm -rf /usr/src/acl-2.2.53

ADD downloads/libcap-2.25.tar.gz /usr/src
RUN \
    cd /usr/src/libcap-2.25 && \
        sed -e 's@__le32@__u32@g;' libcap/include/uapi/linux/capability.h > \
	    libcap/include/uapi/linux/capability.h_ && \
	    rm -f libcap/include/uapi/linux/capability.h && \
	    mv libcap/include/uapi/linux/capability.h_ \
	       libcap/include/uapi/linux/capability.h && \
	make CFLAGS="$CFLAGS -D__u32=uint32_t -D__le32=uint32_t" -C libcap && \
	make -C libcap INCDIR=/usr/include LIBDIR=/usr/lib \
	install && cp -r libcap/include/uapi/linux/ /usr/include/ && \
	rm -rf /usr/src/libcap-2.25

ENV PYTHON_VER=2.7.16
ADD downloads/Python-$PYTHON_VER.tgz /usr/src/
ADD Setup.dist /usr/src/Python-$PYTHON_VER/Modules/Setup.dist
RUN \
    cd /usr/src/Python-$PYTHON_VER && \
    ./configure --prefix=/usr \
      --without-doc-strings --without-tsc \
      --with-fpectl --with-ensurepip=install --with-signal-module \
      --enable-ipv6 --enable-$PYTHON_ABI_MODE --enable-unicode=ucs4  CFLAGS="$CFLAGS -DXML_DEV_URANDOM" && \
    make && make install && ( if [ x"$PYTHON_ABI_MODE" = x"static" ]; then \
    gcc --without-libgcc -shared -fPIC \
        -o /usr/lib/libpython2.7.so \
        -Wl,-whole-archive -Wl,-soname,libpython2.7.so.1.0 libpython2.7.a -Wl,--no-whole-archive \
        -lutil -lz -lm -ldl -lcrypto -lssl -lpthread \
        -Wl,-no-undefined; fi ) && \
    rm -rf /usr/src/Python-$PYTHON_VER

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
    make LDFLAGS="$LDFLAGS -lpython2.7" && make install && rm -rf /usr/src/dbus-python-0.84.0

ADD downloads/gobject-introspection-1.32.1.tar.xz /usr/src/
RUN \
    cd /usr/src/gobject-introspection-1.32.1 && \
    CFLAGS="$CFLAGS -D_GNU_SOURCE" LDFLAGS="$LDFLAGS -lpython2.7"\
        ./configure --prefix=/usr --disable-tests && make && \
    make install && rm -rf /usr/src/gobject-introspection-1.32.1

ADD downloads/pygobject-3.2.2.tar.xz /usr/src/
RUN \
    cd /usr/src/pygobject-3.2.2 && CFLAGS="$CFLAGS -D_GNU_SOURCE" LDFLAGS="$LDFLAGS -lpython2.7" \
	./configure --disable-glibtest \
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

ENV KRB5_VER=1.17-final
ADD downloads/krb5-$KRB5_VER.tar.gz /usr/src
RUN \
    cd /usr/src/krb5-krb5-$KRB5_VER/src && \
    autoreconf -i && CFLAGS="$CFLAGS -DAI_NUMERICSERV=0x0400" ./configure --prefix=/usr \
	--without-readline --without-libedit --without-lmdb --without-keyutils --with-crypto-impl=openssl \
	--without-ldap --without-hesiod --with-size-optimizations --disable-nls --disable-rpath \
	--disable-aesni --disable-pkinit --enable-dns-for-realm --enable-static --disable-shared \
	--without-vague-errors --disable-pkinit --disable-athena --with-spake-openssl && \
	make && make install
RUN \
    cp /usr/bin/krb5-config /usr/bin/krb5-config.bak && \
    sed /usr/bin/krb5-config -e \
	's@echo $lib_flags@echo "-Wl,-no-undefined -Wl,--start-group $lib_flags -lkrb5support -Wl,--end-group \
	$GEN_LIB $LIBS $DL_LIB"@g' < /usr/bin/krb5-config.bak > /usr/bin/krb5-config && \
    rm /usr/bin/krb5-config.bak

ADD downloads/alsa-lib-1.0.15.tar.bz2 /usr/src
RUN \
   cd /usr/src/alsa-lib-1.0.15/ && \
	./configure --prefix=/usr --with-versioned --enable-shared \
	--disable-static && make && make install && \
	rm -rf /usr/src/alsa-lib-1.0.15

ADD downloads/pa_stable_v190600_20161030.tgz /usr/src
RUN \
    cd /usr/src/portaudio && ./configure --prefix=/usr \
	--with-alsa --with-pic --enable-static --disable-shared && \
	make && make install && rm -rf /usr/src/portaudio

ADD downloads/opus-1.3.tar.gz /usr/src
RUN \
   cd /usr/src/opus-1.3 && ./configure --prefix=/usr \
	--enable-static --disable-shared --disable-intrinsics \
	--disable-rtcd && make && make install && \
   rm -rf /usr/src/opus-1.3

RUN \
    rm -rf /usr/share/locale /usr/share/man /usr/share/info

RUN \
    cd /usr/lib/python2.7 && rm -rf test lib2to3 && \
    find -name "*.so" | while read f; do strip $f; done && \
    rm -rf /usr/src && ldconfig && \
    apt-get clean

RUN mkdir -p /build/workspace/project

FROM scratch
COPY --from=0 / /

ENV \
    CFLAGS="-Os -DNDEBUG -fPIC -pipe -L/opt/static" \
    CXXFLAGS="-Os -DNDEBUG -fPIC -pipe" \
    LDFLAGS="-s -O1 -fPIC -L/opt/static" \
    LC_ALL=C \
    TERM= \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/build/workspace/project:/build/workspace/.local/bin \
    WORKSPACE=/build/workspace \
    PROJECT=/build/workspace/project \
    TOOLCHAIN_ARCH=x86

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with python and ancient 32bit ABI"
