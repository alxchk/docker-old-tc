FROM alxchk/linux64
LABEL maintainer "alxchk@gmail.com"

ENV LC_ALL en_US.utf8
ENV MAKEOPTS -j2
ENV TERM ""
ENV DEBIAN_FRONTEND noninteractive
ENV CFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -Os -fPIC -pipe -L/opt/static 
ENV CXXFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -fvisibility=hidden -Os -fPIC -pipe -L/opt/static
ENV LDFLAGS -Os -fPIC -L/opt/static -static-libgcc -Wl,--no-undefined
ENV PYTHON_ABI_MODE shared
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/

USER 0:0

ADD compat /usr/include/

ADD downloads/make-3.82.tar.gz /usr/src/
RUN \
    cd /usr/src/make-3.82 && \
    ./configure && make && make install && \
    apt-get --force-yes -y remove make < /dev/null && \
    rm -rf /usr/src/make-3.82

ARG ZLIB_VER=1.2.11
ADD downloads/zlib-$ZLIB_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/zlib-$ZLIB_VER && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --static && make && make install && \
    rm -rf /usr/src/zlib-$ZLIB_VER

ARG BZIP_VER=1.0.6
ADD downloads/bzip2_$BZIP_VER.orig.tar.bz2 /usr/src/
RUN \
    cd /usr/src/bzip2-$BZIP_VER && \
    make CFLAGS="$CFLAGS -fvisibility=hidden" LDFLAGS="$LDFLAGS" && \
    make PREFIX=/usr install && \
    rm -rf /usr/src/bzip2-$BZIP_VER

ADD downloads/pkg-config-0.29.1.tar.gz /usr/src/
RUN \
    cd /usr/src/pkg-config-0.29.1 && \
    ./configure --with-internal-glib --prefix=/usr && \
    make install && rm -rf /usr/src/pkg-config-0.29.1

ADD downloads/libffi_3.2.1.orig.tar.gz /usr/src/
RUN \
    cd /usr/src/libffi-3.2.1 && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure -enable-static --disable-shared --prefix=/usr && \
    make install && rm -rf /usr/src/libffi-3.2.1

ARG SQLITE_VER=3300100
ADD downloads/sqlite-autoconf-$SQLITE_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/sqlite-autoconf-$SQLITE_VER && \
    CFLAGS="$CFLAGS -fvisibility=hidden" ./configure --prefix=/usr --disable-static-shell \
    --disable-dynamic-extensions --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/sqlite-autoconf-$SQLITE_VER

ADD downloads/attr-2.4.48.tar.gz /usr/src
RUN \
   cd /usr/src/attr-2.4.48 && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --enable-static \
    --disable-shared && sed -i include/attributes.h -e 's@__attribute__@;//__attribute__@g' && \
    make && make install && rm -rf /usr/src/attr-2.4.48

ADD downloads/acl-2.2.53.tar.gz /usr/src
RUN \
   cd /usr/src/acl-2.2.53 && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --enable-static \
    --disable-shared \
    ac_cv_lib_attr_getxattr=yes \
    && make && make install && rm -rf /usr/src/acl-2.2.53

ADD downloads/libcap-2.25.tar.gz /usr/src
RUN \
    cd /usr/src/libcap-2.25 && \
    make CFLAGS="$CFLAGS -fvisibility=hidden -D__u32=uint32_t -D__le32=uint32_t" -C libcap && \
    make -C libcap INCDIR=/usr/include LIBDIR=/usr/lib \
    install && cp -r libcap/include/uapi/linux/ /usr/include/ && \
    rm -rf /usr/src/libcap-2.25 && rm -f /usr/lib/libcap.so*

ADD downloads/perl-5.30.1.tar.gz /usr/src
RUN \
    cd /usr/src/perl-5.30.1 && ./Configure -des -Dprefix=/opt/perl5 && \
        make && make install && cd / && rm -rf /usr/src/perl-5.30.1

ENV PATH=/opt/perl5/bin:$PATH
ENV LDFLAGS -s -Os -fPIC -L/opt/static \
        -static-libgcc -Wl,--no-undefined -Wl,--gc-sections

ARG OPENSSL_VER=1.1.1g
ADD downloads/openssl-$OPENSSL_VER.tar.gz /usr/src/
RUN \
    cd /usr/src/openssl-$OPENSSL_VER/ && \
    ./Configure --prefix=/usr \
        shared no-autoload-config no-cms \
        no-dynamic-engine no-dso no-err no-hw no-ssl2 enable-weak-ssl-ciphers no-unit-test \
        no-filenames no-gost no-sctp no-srp no-tests no-ts \
        no-dtls no-dtls1 no-dtls1_2 linux-x86_64 && \
    make depend >/dev/null 2>/dev/null && \
    make && make install_sw && \
    cp libssl.so.1.1 /usr/lib/libssl.so && \
    cp libcrypto.so.1.1 /usr/lib/libcrypto.so && \
    mkdir -p /usr/lib/pkgconfig/ && \
    cp *.pc /usr/lib/pkgconfig/ && \
    cd /usr/lib && \
    ldconfig -n . && \
    ln -s /usr/lib/libssl.so /usr/lib/libssl.so.1 && \
    ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.1 && \
    cd /usr/src/openssl-$OPENSSL_VER/ && make clean && \
    cd / && rm -rf /usr/src/openssl-$OPENSSL_VER

ARG PYTHON_VER=2.7.18
ADD downloads/Python-$PYTHON_VER.tgz /usr/src/
ADD Setup.dist /usr/src/Python-$PYTHON_VER/Modules/Setup.dist
RUN \
    cd /usr/src/Python-$PYTHON_VER && \
    ./configure --prefix=/usr \
      --without-doc-strings --without-tsc \
      --with-fpectl --with-ensurepip=install --with-signal-module \
    --enable-ipv6 --enable-unicode=ucs4 --enable-$PYTHON_ABI_MODE \
    CFLAGS="$CFLAGS -DXML_DEV_URANDOM" LDFLAGS="$LDFLAGS -ldl -lpthread -lm" && \
    make && make install && ( if [ x"$PYTHON_ABI_MODE" = x"static" ]; then  \
    gcc --without-libgcc -pthread -shared -fPIC \
        -o /usr/lib/libpython2.7.so \
        -Wl,-whole-archive -Wl,-soname,libpython2.7.so.1.0 libpython2.7.a -Wl,--no-whole-archive \
        -lutil -lz -lm -ldl -lcrypto -lssl \
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
    cd /usr/src/dbus-glib-0.88 && ./configure --prefix=/usr \
    --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/dbus-glib-0.88

ADD downloads/dbus-python-0.84.0.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-python-0.84.0 && ./configure --prefix=/usr && \
    make LDFLAGS="$LDFLAGS -lpython2.7" && make install && rm -rf /usr/src/dbus-python-0.84.0

ADD downloads/gobject-introspection-1.32.1.tar.xz /usr/src/
RUN \
    cd /usr/src/gobject-introspection-1.32.1 && \
    CFLAGS="$CFLAGS -D_GNU_SOURCE" LDFLAGS="$LDFLAGS -lpython2.7" \
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
    make  -k ; make install; rm -rf /usr/src/pygobject-3.2.2

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

ARG KRB5_VER=1.17-final
ADD downloads/krb5-$KRB5_VER.tar.gz /usr/src
RUN \
    cd /usr/src/krb5-krb5-$KRB5_VER/src && \
    autoreconf -i && CFLAGS="$CFLAGS -DAI_NUMERICSERV=0x0400 -fvisibility=hidden" \
    LDFLAGS="$LDFLAGS -pthread" ./configure --prefix=/usr \
    --without-readline --without-libedit --without-lmdb --without-keyutils --with-crypto-impl=openssl \
    --without-ldap --without-hesiod --with-size-optimizations --disable-nls --disable-rpath \
    --disable-aesni --disable-pkinit --enable-dns-for-realm --enable-static --disable-shared \
    --without-vague-errors --disable-pkinit --disable-athena --with-spake-openssl && \
    make && make install
RUN \
    sed -i /usr/bin/krb5-config -e \
    's@echo $lib_flags@echo "-Wl,-no-undefined -Wl,--start-group $lib_flags -lkrb5support -Wl,--end-group \
    $GEN_LIB $LIBS $DL_LIB"@g' && rm -rf /usr/src/krb5-krb5-$KRB5_VER

ADD downloads/alsa-lib-1.0.15.tar.bz2 /usr/src
RUN \
   apt-get remove -y libasound2 && cd /usr/src/alsa-lib-1.0.15/ && \
	LDFLAGS="$LDFLAGS -ldl" ./configure --prefix=/usr --with-versioned --enable-shared \
	--disable-static && make && make install && \
	rm -rf /usr/src/alsa-lib-1.0.15

ARG ODBC_VER=2.3.7
ADD downloads/unixODBC-$ODBC_VER.tar.gz /usr/src
RUN \
    cd /usr/src/unixODBC-$ODBC_VER && \
    ./configure --prefix=/usr --sysconfdir=/etc --enable-inicaching \
    --disable-readline --enable-setlibversion \
    --enable-shared --disable-static && \
    make && make install && rm -rf /usr/src/unixODBC-$ODBC_VER

ADD downloads/pa_stable_v190600_20161030.tgz /usr/src
RUN \
    cd /usr/src/portaudio && CFLAGS="$CFLAGS -fvisibility=hidden" ./configure --prefix=/usr \
    --with-alsa --with-pic --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/portaudio

ADD downloads/opus-1.3.tar.gz /usr/src
RUN \
   cd /usr/src/opus-1.3 && CFLAGS="$CFLAGS -fvisibility=hidden" ./configure --enable-fixed-point --prefix=/usr \
    --enable-static --disable-shared && make && make install && \
   rm -rf /usr/src/opus-1.3

ARG PG_VER=12.0
ADD downloads/postgresql-$PG_VER.tar.gz /usr/src
RUN \
    cd /usr/src/postgresql-$PG_VER && \
        ./configure --without-gssapi --without-readline \
        --with-openssl --prefix=/usr --sysconfdir=/etc && \
        make -C src/interfaces/libpq install && \
        make -C src/bin/pg_config install && \
        make -C src/backend generated-headers && \
        make -C src/include install && \
    rm -rf /usr/src/postgresql-PG_VER

ARG PGODBC_VER=12.00.0000
ADD downloads/psqlodbc-$PGODBC_VER.tar.gz /usr/src
RUN cd /usr/src/psqlodbc-$PGODBC_VER && \
    ( ./configure --prefix=/usr --sysconfdir=/etc && \
    make && make install && rm -rf /usr/src/postgresql-$PG_VER ) || \
    ( cat config.log ; exit 1)

ADD downloads/libidn-1.11.tar.gz /usr/src
RUN \
    cd /usr/src/libidn-1.11 && \
        ./configure --prefix=/usr -enable-static --enable-shared  && \
        make && make install && \
        rm -rf /usr/src/libidn-1.11

ADD downloads/cmake-3.1.3-Linux-x86_64.tar.gz /usr/src
RUN \
    cp -r /usr/src/cmake-3.1.3-Linux-x86_64/* / && \
    rm -rf /usr/src/cmake-3.1.3-Linux-x86_64

ARG MYSQLC_VER=3.1.6
ADD downloads/mariadb-connector-c-$MYSQLC_VER-src.tar.gz /usr/src
ADD downloads/mariadb-connector-odbc-$MYSQLC_VER-ga-src.tar.gz /usr/src
RUN \
    mv /usr/src/mariadb-connector-c-$MYSQLC_VER-src \
        /usr/src/mariadb-connector-odbc-$MYSQLC_VER-ga-src/libmariadb && \
    cd /usr/src/mariadb-connector-odbc-$MYSQLC_VER-ga-src && \
    sed -e 's@defined(__GNUC__)@0@g' libmariadb/include/ma_context.h > \
        libmariadb/include/ma_context.h_ && \
    mv -f libmariadb/include/ma_context.h_ libmariadb/include/ma_context.h && \
    cmake -DCONC_WITH_UNIT_TESTS=Off -DWITH_SSL=OPENSSL -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr . && make maodbc && cp -vf libmaodbc.so /usr/lib/ && \
    rm -rf /usr/src/mariadb-connector-odbc-$MYSQLC_VER-ga-src

RUN \
    rm -rf /usr/share/locale /usr/share/man /usr/share/info

RUN \
    cd /usr/lib/python2.7 && rm -rf test lib2to3 && \
    find -name "*.so" | while read f; do strip $f; done && \
    rm -rf /usr/src && ldconfig && \
    apt-get clean

RUN mkdir -p /build/workspace/project

RUN \
    find / -noleaf -xdev ! -uid 0 -or ! -gid 0 -exec chown 0:0 '{}' ';'

ENV PATH $PATH:/build/workspace/project:/build/workspace/.local/bin
ENV WORKSPACE /build/workspace
ENV PROJECT /build/workspace/project
ENV TOOLCHAIN_ARCH amd64

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with python and ancient 64bit ABI"
