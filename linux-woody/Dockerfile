ARG NAMESPACE=
FROM ${NAMESPACE}linux-i386:woody

LABEL maintainer "alxchk@gmail.com"

ADD compat /usr/include/
RUN cat /usr/include/pthread-compat.h >>/usr/include/pthread.h

ENV LC_ALL en_US.utf8
ENV MAKEOPTS -j2
ENV TERM ""
ENV DEBIAN_FRONTEND noninteractive
ENV CFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -Os -fPIC -pipe -L/opt/static
ENV CXXFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -fvisibility=hidden -Os -fPIC -pipe -L/opt/static
ENV LDFLAGS -fPIC -L/opt/static -static-libgcc -Wl,--no-undefined
ENV PYTHON_ABI_MODE shared
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/

USER 0:0

ARG VER_MAKE=3.82
ADD downloads/make-$VER_MAKE.tar.gz /usr/src/
RUN \
    cd /usr/src/make-$VER_MAKE && \
    ./configure && make && make install && \
    apt-get --force-yes -y remove make < /dev/null && \
    rm -rf /usr/src/make-$VER_MAKE

ARG VER_ZLIB=1.2.11
ADD downloads/zlib-$VER_ZLIB.tar.gz /usr/src/
RUN \
    cd /usr/src/zlib-$VER_ZLIB && \
    ./configure --prefix=/usr --static && make && make install && \
    rm -rf /usr/src/zlib-$VER_ZLIB

ARG VER_BZIP=1.0.6
ADD downloads/bzip2_$VER_BZIP.orig.tar.bz2 /usr/src/
RUN \
    cd /usr/src/bzip2-$VER_BZIP && \
    make CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" && make PREFIX=/usr install && \
    rm -rf /usr/src/bzip2-$VER_BZIP

ARG VER_LIBFFI=3.2.1
ADD downloads/libffi_$VER_LIBFFI.orig.tar.gz /usr/src/
RUN \
    cd /usr/src/libffi-$VER_LIBFFI && \
    ./configure --enable-static --prefix=/usr && \
    make install && rm -rf /usr/src/libffi-$VER_LIBFFI

ARG VER_PKGCONFIG=0.29.1
ADD downloads/pkg-config-$VER_PKGCONFIG.tar.gz /usr/src/
RUN \
    cd /usr/src/pkg-config-$VER_PKGCONFIG && \
    ./configure --with-internal-glib --prefix=/usr && \
    make install && rm -rf /usr/src/pkg-config-$VER_PKGCONFIG

ARG VER_LIBATTR=2.4.48
ADD downloads/attr-$VER_LIBATTR.tar.gz /usr/src
RUN \
    cd /usr/src/attr-$VER_LIBATTR && ./configure --prefix=/usr --enable-static \
	--disable-shared && make && make install && rm -rf /usr/src/attr-$VER_LIBATTR

ARG VER_LIBACL=2.2.53
ADD downloads/acl-$VER_LIBACL.tar.gz /usr/src
RUN \
    cd /usr/src/acl-$VER_LIBACL && ./configure --prefix=/usr --enable-static \
	--disable-shared \
	ac_cv_lib_attr_getxattr=yes \
	&& make && make install && rm -rf /usr/src/acl-$VER_LIBACL

ARG VER_SQLITE=3300100
ADD downloads/sqlite-autoconf-$VER_SQLITE.tar.gz /usr/src/
RUN \
    cd /usr/src/sqlite-autoconf-$VER_SQLITE && \
    ./configure --prefix=/usr --disable-static-shell \
	--disable-dynamic-extensions -enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/sqlite-autoconf-$VER_SQLITE

ARG VER_PERL=5.30.1
ADD downloads/perl-$VER_PERL.tar.gz /usr/src
RUN \
    cd /usr/src/perl-$VER_PERL && ./Configure -des -Dprefix=/opt/perl5 && \
        make && make install && cd / && rm -rf /usr/src/perl-$VER_PERL

ENV PATH=/opt/perl5/bin:$PATH
ENV LDFLAGS -s -Os -fPIC -L/opt/static \
        -static-libgcc -Wl,--no-undefined -Wl,--gc-sections

ARG VER_OPENSSL=1.1.1g
ADD downloads/openssl-$VER_OPENSSL.tar.gz /usr/src/
RUN \
    cd /usr/src/openssl-$VER_OPENSSL/ && \
    LDFLAGS="$LDFLAGS -lpthread" \
    ./Configure --prefix=/usr shared \
        no-autoload-config no-cms \
        no-dynamic-engine no-dso no-err no-hw no-ssl2 enable-weak-ssl-ciphers no-unit-test \
        no-filenames no-gost no-sctp no-srp no-tests no-ts \
        no-dtls no-dtls1 no-dtls1_2 linux-generic32 && \
    make depend >/dev/null 2>/dev/null && \
    make && make install_sw && \
    cp libssl.so.1.1 /usr/lib/libssl.so && \
    cp libcrypto.so.1.1  /usr/lib/libcrypto.so && \
    mkdir -p /usr/lib/pkgconfig/ && \
    cp *.pc /usr/lib/pkgconfig/ && \
    cd /usr/lib && \
    ldconfig -n . && \
    ln -s /usr/lib/libssl.so /usr/lib/libssl.so.1 && \
    ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.1 && \
    cd /usr/src/openssl-$VER_OPENSSL/ && make clean && \
    cd / && rm -rf /usr/src/openssl-$VER_OPENSSL

ARG VER_LIBCAP=2.25
ADD downloads/libcap-$VER_LIBCAP.tar.gz /usr/src
RUN \
    cd /usr/src/libcap-$VER_LIBCAP && \
        sed -e 's@__le32@__u32@g;' libcap/include/uapi/linux/capability.h > \
	    libcap/include/uapi/linux/capability.h_ && \
	    rm -f libcap/include/uapi/linux/capability.h && \
	    mv libcap/include/uapi/linux/capability.h_ \
	       libcap/include/uapi/linux/capability.h && \
	make CFLAGS="$CFLAGS -D__u32=uint32_t -D__le32=uint32_t" -C libcap && \
	make -C libcap INCDIR=/usr/include LIBDIR=/usr/lib \
	install && cp -r libcap/include/uapi/linux/ /usr/include/ && \
	rm -rf /usr/src/libcap-$VER_LIBCAP && rm -f /usr/lib/libcap.so*

ARG VER_PYTHON=2.7.18
ADD downloads/Python-$VER_PYTHON.tgz /usr/src/
ADD pysetup/Setup.dist /usr/src/Python-$VER_PYTHON/Modules/Setup.dist
RUN \
    cd /usr/src/Python-$VER_PYTHON && \
    ./configure --prefix=/usr \
      --without-doc-strings --without-tsc \
      --with-fpectl --with-ensurepip=install --with-signal-module \
      --enable-ipv6 --enable-$PYTHON_ABI_MODE --enable-unicode=ucs4 \
    CFLAGS="$CFLAGS -DXML_DEV_URANDOM" LDFLAGS="$LDFLAGS -ldl -lpthread -lm" && \
    make && make install && ( if [ x"$PYTHON_ABI_MODE" = x"static" ]; then \
    gcc --without-libgcc -shared -fPIC \
        -o /usr/lib/libpython2.7.so \
        -Wl,-whole-archive -Wl,-soname,libpython2.7.so.1.0 libpython2.7.a -Wl,--no-whole-archive \
        -lutil -lz -lm -ldl -lcrypto -lssl -lpthread \
        -Wl,-no-undefined; fi ) && \
    rm -rf /usr/src/Python-$VER_PYTHON

ARG VER_GLIB=2.32.4
ADD downloads/glib-$VER_GLIB.tar.xz /usr/src/
RUN \
    cd /usr/src/glib-$VER_GLIB && \
    CFLAGS="$CFLAGS -DPR_SET_NAME=15 -DPR_GET_NAME=16" ./configure \
        --prefix=/usr --disable-xattr --disable-fam --disable-selinux \
        --enable-static && \
    make -k ; make -k install ; rm -rf /usr/src/glib-$VER_GLIB

ARG VER_DBUS=1.2.12
ADD downloads/dbus-$VER_DBUS.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-$VER_DBUS && ./configure --prefix=/usr \
        --disable-selinux --disable-libaudit \
        --disable-dnotify --disable-inotify --disable-kqueue \
        --disable-userdb-cache --enable-abstract-sockets && \
    make && make install && rm -rf /usr/src/dbus-$VER_DBUS

ARG VER_DBUS_GLIB=0.88
ADD downloads/dbus-glib-$VER_DBUS_GLIB.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-glib-$VER_DBUS_GLIB && ./configure --prefix=/usr \
    --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/dbus-glib-$VER_DBUS_GLIB

ARG VER_DBUS_PYTHON=0.84.0
ADD downloads/dbus-python-$VER_DBUS_PYTHON.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-python-$VER_DBUS_PYTHON && ./configure --prefix=/usr && \
    make LDFLAGS="$LDFLAGS -lpython2.7" && make install && rm -rf /usr/src/dbus-python-$VER_DBUS_PYTHON

ARG VER_GOBJECT_INTROSPECTION=1.32.1
ADD downloads/gobject-introspection-$VER_GOBJECT_INTROSPECTION.tar.xz /usr/src/
RUN \
    cd /usr/src/gobject-introspection-$VER_GOBJECT_INTROSPECTION && \
    LDFLAGS="$LDFLAGS -lpython2.7"\
        ./configure --prefix=/usr --disable-tests && make && \
    make install && rm -rf /usr/src/gobject-introspection-$VER_GOBJECT_INTROSPECTION

ARG VER_PYGOBJECT=3.2.2
ADD downloads/pygobject-$VER_PYGOBJECT.tar.xz /usr/src/
RUN \
    cd /usr/src/pygobject-$VER_PYGOBJECT && LDFLAGS="$LDFLAGS -lpython2.7" \
	./configure --disable-glibtest \
	--disable-cairo --prefix=/usr --enable-static && make -k ; \
    [ -f ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0.0.0 ] && \
    rm -f ./gi/_glib/.libs/libpyglib-gi-2.0-python.so{,.0,.0.0.0} && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0 && \
    ln -s libpyglib-gi-2.0-python.a ./gi/_glib/.libs/libpyglib-gi-2.0-python.so.0.0.0 && \
    rm -f ./gi/_gi.la ./gi/_gobject/_gobject.la ./gi/_glib/_glib.la && \
    rm -f ./gi/.libs/_gi.la ./gi/_gobject/.libs/_gobject.la ./gi/_glib/.libs/_glib.la && \
    make -k ; make install; rm -rf /usr/src/pygobject-$VER_PYGOBJECT

ARG VER_M4=1.4.18
ADD downloads/m4-$VER_M4.tar.gz /usr/src/
RUN \
    cd /usr/src/m4-$VER_M4 && \
    ./configure --prefix=/usr && make && make install && \
    rm -rf /usr/src/m4-$VER_M4

ARG VER_AUTOCONF=2.69
ADD downloads/autoconf-$VER_AUTOCONF.tar.gz /usr/src/
RUN \
    cd /usr/src/autoconf-$VER_AUTOCONF && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/autoconf-$VER_AUTOCONF

ARG VER_AUTOMAKE=1.15
ADD downloads/automake-$VER_AUTOMAKE.tar.gz /usr/src/
RUN \
    cd /usr/src/automake-$VER_AUTOMAKE && ./configure --prefix=/usr && \
    make && make install && rm -rf /usr/src/automake-$VER_AUTOMAKE

ARG VER_KRB5=1.17-final
ADD downloads/krb5-$VER_KRB5.tar.gz /usr/src
RUN \
    cd /usr/src/krb5-krb5-$VER_KRB5/src && \
    sed < lib/krb5/unicode/Makefile.in -e 's@find $(srcdir)@find $(srcdir)/*@' > \
        lib/krb5/unicode/Makefile.in.tmp && \
        mv -f lib/krb5/unicode/Makefile.in.tmp lib/krb5/unicode/Makefile.in && \
    autoreconf -i && CFLAGS="$CFLAGS -DAI_NUMERICSERV=0x0400" LDFLAGS="$LDFLAGS -pthread" \
    ./configure --prefix=/usr \
	--without-readline --without-libedit --without-lmdb --with-crypto-impl=openssl \
	--without-ldap --without-hesiod --with-size-optimizations --disable-nls --disable-rpath \
	--disable-aesni --disable-pkinit --enable-dns-for-realm --enable-static --disable-shared \
	--without-vague-errors --disable-pkinit --disable-athena --with-spake-openssl && \
	make && make install
RUN \
    cp -vf /usr/bin/krb5-config /usr/bin/krb5-config.bak && \
    sed /usr/bin/krb5-config -e \
	's@echo $lib_flags@echo "-Wl,-no-undefined -Wl,--start-group $lib_flags -lkrb5support -Wl,--end-group \
	$GEN_LIB $LIBS $DL_LIB"@g' /usr/bin/krb5-config.bak > /usr/bin/krb5-config && \
    rm /usr/bin/krb5-config.bak && rm -rf /usr/src/krb5-krb5-$VER_KRB5

ARG VER_ODBC=2.3.7
ADD downloads/unixODBC-$VER_ODBC.tar.gz /usr/src
RUN \
    cd /usr/src/unixODBC-$VER_ODBC && \
    ./configure --prefix=/usr --sysconfdir=/etc --enable-inicaching \
    --disable-readline --enable-setlibversion \
    --enable-shared --disable-static && \
    make && make install && rm -rf /usr/src/unixODBC-$VER_ODBC

ARG VER_LIBALSA=1.0.15
ADD downloads/alsa-lib-$VER_LIBALSA.tar.bz2 /usr/src
RUN \
   cd /usr/src/alsa-lib-$VER_LIBALSA/ && \
	LDFLAGS="$LDFLAGS -ldl" ./configure --prefix=/usr --with-versioned --enable-shared \
	--disable-static && make && make install && \
	rm -rf /usr/src/alsa-lib-$VER_LIBALSA

ARG VER_PORTAUDIO=v190600_20161030
ADD downloads/pa_stable_$VER_PORTAUDIO.tgz /usr/src
RUN \
    cd /usr/src/portaudio && ./configure --prefix=/usr \
	--with-alsa --with-pic --enable-static --disable-shared && \
	make && make install && rm -rf /usr/src/portaudio

ARG VER_OPUS=1.3
ADD downloads/opus-$VER_OPUS.tar.gz /usr/src
RUN \
   cd /usr/src/opus-$VER_OPUS && ./configure --prefix=/usr \
	--enable-static --disable-shared --disable-intrinsics \
	--disable-rtcd && make && make install && \
   rm -rf /usr/src/opus-$VER_OPUS

ARG VER_PG=12.0
ADD downloads/postgresql-$VER_PG.tar.gz /usr/src
RUN \
    cd /usr/src/postgresql-$VER_PG && \
        LDFLAGS="$LDFLAGS -lpthread" ./configure --without-gssapi --without-readline \
        --with-openssl --prefix=/usr --sysconfdir=/etc && \
        make -C src/interfaces/libpq install && \
        make -C src/bin/pg_config install && \
        make -C src/backend generated-headers && \
        make -C src/include install && \
    rm -rf /usr/src/postgresql-$VER_PG

ARG VER_PGODBC=12.00.0000
ADD downloads/psqlodbc-$VER_PGODBC.tar.gz /usr/src
RUN cd /usr/src/psqlodbc-$VER_PGODBC && \
    ( ./configure --prefix=/usr --sysconfdir=/etc && \
    make && make install && rm -rf /usr/src/psqlodbc-$VER_PG ) || \
    ( cat config.log ; exit 1)

ARG VER_CMAKE=2.8.12.2
ARG CMAKE_ARCH=$UNAME_ARCH
ADD downloads/cmake-$VER_CMAKE-Linux-$CMAKE_ARCH.tar.gz /usr/src/
RUN mv /usr/src/cmake-$VER_CMAKE-Linux-$CMAKE_ARCH/bin/* /usr/bin/ && \
	mv /usr/src/cmake-$VER_CMAKE-Linux-$CMAKE_ARCH/share/cmake* /usr/share/ && \
	rm -rf /usr/src/cmake-*

ARG VER_MARIADBODBC=3.1.6
ADD downloads/mariadb-connector-c-$VER_MARIADBODBC-src.tar.gz /usr/src
ADD downloads/mariadb-connector-odbc-$VER_MARIADBODBC-ga-src.tar.gz /usr/src
RUN \
    mv /usr/src/mariadb-connector-c-$VER_MARIADBODBC-src \
        /usr/src/mariadb-connector-odbc-$VER_MARIADBODBC-ga-src/libmariadb && \
    cd /usr/src/mariadb-connector-odbc-$VER_MARIADBODBC-ga-src && \
    sed -e 's@defined(__GNUC__)@0@g' libmariadb/include/ma_context.h > \
        libmariadb/include/ma_context.h_ && \
    mv libmariadb/include/ma_context.h_ libmariadb/include/ma_context.h && \
    cmake -DCONC_WITH_UNIT_TESTS=Off -DWITH_SSL=OPENSSL -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr . && make maodbc && cp -vf libmaodbc.so /usr/lib/ && \
    rm -rf /usr/src/mariadb-*

RUN \
    rm -rf /usr/share/locale /usr/share/man /usr/share/info

RUN \
    cd /usr/lib/python2.7 && rm -rf test lib2to3 && \
    find -name "*.so" | while read f; do strip $f; done && \
    rm -rf /usr/src && ldconfig && \
    apt-get clean

RUN mkdir -p /build/workspace/project

RUN \
    find / -xdev ! -uid 0 -or ! -gid 0 -exec chown 0:0 '{}' ';'

ENV PATH $PATH:/build/workspace/project:/build/workspace/.local/bin
ENV WORKSPACE /build/workspace
ENV PROJECT /build/workspace/project
ENV TOOLCHAIN_ARCH x86
ENV TOOLCHAIN_DIST woody
ENV PYMAJ=2
ENV PYMIN=7

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with python and ancient 32bit ABI"
