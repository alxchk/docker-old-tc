ARG ARCH=amd64
ARG UNAME_ARCH=x86_64
ARG DIST=etch
ARG NAMESPACE=

FROM ${NAMESPACE}linux-$ARCH:$DIST
LABEL maintainer "alxchk@gmail.com"

ENV LC_ALL en_US.utf8
ENV MAKEOPTS -j2
ENV TERM ""
ENV DEBIAN_FRONTEND noninteractive
ENV CFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -Os -fPIC -pipe -L/opt/static -L/usr/lib/nptl -L/lib/tls -I/usr/include/nptl -D_REENTERANT
ENV CXXFLAGS -DNDEBUG -D_GNU_SOURCE -D__USE_XOPEN2K8 \
    -fvisibility=hidden -Os -fPIC -pipe -L/opt/static -L/usr/lib/nptl -L/lib/tls -I/usr/include/nptl
ENV LDFLAGS -Os -fPIC -L/usr/lib/nptl -L/opt/static -L/lib/tls -static-libgcc -Wl,--no-undefined -D_REENTERANT
ENV PYTHON_ABI_MODE shared
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/

USER 0:0

ADD compat /usr/include/

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
    cd /usr/src/zlib-$VER_ZLIB && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --static && make && make install && \
    rm -rf /usr/src/zlib-$VER_ZLIB

ARG VER_BZIP=1.0.6
ADD downloads/bzip2_$VER_BZIP.orig.tar.bz2 /usr/src/
RUN \
    cd /usr/src/bzip2-$VER_BZIP && \
    make CFLAGS="$CFLAGS -fvisibility=hidden" LDFLAGS="$LDFLAGS" && \
    make PREFIX=/usr install && \
    rm -rf /usr/src/bzip2-$VER_BZIP

ARG VER_XZ=5.2.5
ADD downloads/xz-$VER_XZ.tar.gz /usr/src/
RUN \
    cd /usr/src/xz-$VER_XZ && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --enable-static --disable-shared && make && make install && \
    rm -rf /usr/src/xz-$VER_XZ

ARG VER_PKGCONFIG=0.29.1
ADD downloads/pkg-config-$VER_PKGCONFIG.tar.gz /usr/src/
RUN \
    cd /usr/src/pkg-config-$VER_PKGCONFIG && \
    ./configure --with-internal-glib --prefix=/usr && \
    make install && rm -rf /usr/src/pkg-config-$VER_PKGCONFIG

ARG VER_LIBFFI=3.2.1
ADD downloads/libffi_$VER_LIBFFI.orig.tar.gz /usr/src/
RUN \
    cd /usr/src/libffi-$VER_LIBFFI && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure -enable-static --disable-shared --prefix=/usr && \
    make install && rm -rf /usr/src/libffi-$VER_LIBFFI

ARG VER_SQLITE=3300100
ADD downloads/sqlite-autoconf-$VER_SQLITE.tar.gz /usr/src/
RUN \
    cd /usr/src/sqlite-autoconf-$VER_SQLITE && \
    CFLAGS="$CFLAGS -fvisibility=hidden" ./configure --prefix=/usr --disable-static-shell \
    --disable-dynamic-extensions --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/sqlite-autoconf-$VER_SQLITE

ARG VER_LIBATTR=2.4.48
ADD downloads/attr-$VER_LIBATTR.tar.gz /usr/src
RUN \
   cd /usr/src/attr-$VER_LIBATTR && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --enable-static \
    --disable-shared && sed -i include/attributes.h -e 's@__attribute__@;//__attribute__@g' && \
    make && make install && rm -rf /usr/src/attr-$VER_LIBATTR

ARG VER_LIBACL=2.2.53
ADD downloads/acl-$VER_LIBACL.tar.gz /usr/src
RUN \
   cd /usr/src/acl-$VER_LIBACL && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --prefix=/usr --enable-static \
    --disable-shared \
    ac_cv_lib_attr_getxattr=yes \
    && make && make install && rm -rf /usr/src/acl-$VER_LIBACL

ARG VER_LIBCAP=2.25
ADD downloads/libcap-$VER_LIBCAP.tar.gz /usr/src
RUN \
    cd /usr/src/libcap-$VER_LIBCAP && \
    make CFLAGS="$CFLAGS -fvisibility=hidden -D__u32=uint32_t -D__le32=uint32_t" -C libcap && \
    make -C libcap INCDIR=/usr/include LIBDIR=/usr/lib \
    install && cp -r libcap/include/uapi/linux/ /usr/include/ && \
    rm -rf /usr/src/libcap-$VER_LIBCAP && rm -f /usr/lib/libcap.so*

ARG VER_PERL=5.30.1
ADD downloads/perl-$VER_PERL.tar.gz /usr/src
RUN \
    cd /usr/src/perl-5.30.1 && ./Configure -des -Dprefix=/opt/perl5 && \
        make && make install && cd / && rm -rf /usr/src/perl-$VER_PERL

ENV PATH=/opt/perl5/bin:$PATH
ENV LDFLAGS -s -Os -fPIC -L/opt/static \
        -static-libgcc -Wl,--no-undefined -Wl,--gc-sections

ARG VER_OPENSSL=1.1.1j
ADD downloads/openssl-$VER_OPENSSL.tar.gz /usr/src/
RUN \
    case "${ARCH}" in \
    	amd64) UNAME_ARCH=x86_64 ;; \
	i386) UNAME_ARCH=x86 ;; \
	*) UNAME_ARCH=$UNAME_ARCH ;; \
    esac; echo "USE UNAME_ARCH=$UNAME_ARCH"; \
    cd /usr/src/openssl-$VER_OPENSSL/ && \
    ./Configure --prefix=/usr \
        shared no-autoload-config no-cms \
        no-dynamic-engine no-dso no-err no-hw no-ssl2 enable-weak-ssl-ciphers no-unit-test \
        no-filenames no-gost no-sctp no-srp no-tests no-ts \
        no-dtls no-dtls1 no-dtls1_2 linux-$UNAME_ARCH && \
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
    cd /usr/src/openssl-$VER_OPENSSL/ && make clean && \
    cd / && rm -rf /usr/src/openssl-$VER_OPENSSL

ARG PYTHON_MAJ=3
ARG PYTHON_MIN=8
ARG PYTHON_REV=6
ARG PYTHON_ABI=$PYTHON_MAJ.$PYTHON_MIN
ARG VER_PYTHON=$PYTHON_MAJ.$PYTHON_MIN.$PYTHON_REV
ADD downloads/Python-$VER_PYTHON.tgz /usr/src/
ADD pysetup/$PYTHON_ABI/* /usr/src/Python-$VER_PYTHON/Modules/
ENV \
    PYTHON_ABI=$PYTHON_ABI \
    VER_PYTHON=$VER_PYTHON
RUN \
    cd /usr/src/Python-$VER_PYTHON && \
    if [ "${PYTHON_MAJ}" = 3 ]; then \
        sed -i Misc/python.pc.in -e 's!@LIBS@!@LIBS@ -L/usr/lib/nptl -L/lib/tls -lpython -pthread@VERSION@!g' && \
        sed -i Misc/python-embed.pc.in -e 's!@LIBS@!@LIBS@ -L/usr/lib/nptl -L/lib/tls -lpython -pthread@VERSION@!g' && \
        sed -i Misc/python-config.in -e "s/'--embed' in opt_flags/True/" && \
        sed -i Misc/python-config.sh.in -e "s/PY_EMBED=0/PY_EMBED=1/"; \
    fi && \
    ./configure --prefix=/usr \
      --without-doc-strings --without-tsc \
      --with-fpectl --with-ensurepip=install --with-signal-module \
    --enable-ipv6 --enable-unicode=ucs4 --enable-$PYTHON_ABI_MODE \
    CFLAGS="$CFLAGS -I/usr/include/nptl -DXML_DEV_URANDOM" \
    LDFLAGS="$LDFLAGS -L/usr/lib/nptl -L/lib/tls -ldl -lm -pthread" && \
    if [ "${PYTHON_MAJ}" = 3 ]; then \
         make python && make LDFLAGS="$LDFLAGS -lpython$PYTHON_ABI" all; \
    else \
         make; \
    fi && make install && ( \
    if [ x"$PYTHON_ABI_MODE" = x"static" ]; then  \
         gcc --without-libgcc -pthread -shared -fPIC \
            -o /usr/lib/libpython$PYTHON_ABI.so \
            -Wl,-whole-archive -Wl,-soname,libpython$PYTHON_ABI.so.1.0 \
       	libpython$PYTHON_ABI.a -Wl,--no-whole-archive \
            -lutil -lz -lm -ldl -lcrypto -lssl -Wl,-no-undefined; \
    fi ) && \
    if [ "${PYTHON_MAJ}" = 3 ]; then \
        ln -sf /usr/bin/python3 /usr/bin/python && \
        ln -sf /usr/bin/python3-config /usr/bin/python-config; \
    fi && \
    rm -rf /usr/src/Python-$VER_PYTHON

ARG VER_GLIB=2.52.3
ADD downloads/glib-$VER_GLIB.tar.xz /usr/src/
RUN \
    cd /usr/src/glib-$VER_GLIB && \
    CFLAGS="$CFLAGS -DPR_SET_NAME=15 -DPR_GET_NAME=16 -DO_CLOEXEC=02000000 -Dmkostemp\\(x,y\\)=mkstemp\\(x\\)" \
	./configure \
        --prefix=/usr --disable-xattr --disable-fam --disable-selinux \
	--disable-libmount --disable-libelf --disable-man --enable-static \
	--disable-gtk-doc-html --disable-always-build-tests --disable-installed-tests \
        --enable-debug=no --with-pcre=internal && \
    make && make install && rm -rf /usr/src/glib-$VER_GLIB

ARG VER_DBUS=1.8.22
ADD downloads/dbus-$VER_DBUS.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-$VER_DBUS && ./configure --prefix=/usr \
        --disable-selinux --disable-libaudit \
        --disable-dnotify --disable-inotify --disable-kqueue \
        --disable-userdb-cache --enable-abstract-sockets \
	 LDFLAGS="$LDFLAGS -pthread" && \
    make && make install && rm -rf /usr/src/dbus-$VER_DBUS

ARG VER_DBUS_GLIB=0.108
ADD downloads/dbus-glib-$VER_DBUS_GLIB.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-glib-$VER_DBUS_GLIB && ./configure --prefix=/usr \
    --enable-static --disable-shared LDFLAGS="$LDFLAGS -pthread" && \
    make && make install && rm -rf /usr/src/dbus-glib-$VER_DBUS_GLIB

ARG VER_DBUS_PYTHON=1.2.16
ADD downloads/dbus-python-$VER_DBUS_PYTHON.tar.gz /usr/src/
RUN \
    cd /usr/src/dbus-python-$VER_DBUS_PYTHON && \
	./configure --prefix=/usr \
  	    LDFLAGS="$LDFLAGS -lpython$PYTHON_ABI -pthread" && \
    make && make install && rm -rf /usr/src/dbus-python-$VER_DBUS_PYTHON

ARG VER_GOBJECT_INTROSPECTION=1.52.1
ADD downloads/gobject-introspection-$VER_GOBJECT_INTROSPECTION.tar.xz /usr/src/
RUN \
    cd /usr/src/gobject-introspection-$VER_GOBJECT_INTROSPECTION && \
	./configure --prefix=/usr --disable-tests && \
	make am__append_3="-lpython$PYTHON_ABI -pthread" SUBDIRS=. && \
    make install && rm -rf /usr/src/gobject-introspection-$VER_GOBJECT_INTROSPECTION

ARG VER_PYGOBJECT=3.17.90
ADD downloads/pygobject-$VER_PYGOBJECT.tar.xz /usr/src/
RUN \
    cd /usr/src/pygobject-$VER_PYGOBJECT && \
    sed -i Makefile.in -e 's@examples gi tests@gi@g' && \
    ./configure --disable-glibtest \
	--disable-cairo --prefix=/usr --enable-static SUBDIRS=gi && \
	make extension_libadd="-lpython$PYTHON_ABI -pthread" && \
        make am__py_compile=true install && rm -rf /usr/src/pygobject-$VER_PYGOBJECT

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
    $GEN_LIB $LIBS $DL_LIB"@g' && rm -rf /usr/src/krb5-krb5-$VER_KRB5

ARG VER_LIBALSA=1.0.15
ADD downloads/alsa-lib-$VER_LIBALSA.tar.bz2 /usr/src
RUN \
   apt-get remove -y libasound2 && cd /usr/src/alsa-lib-$VER_LIBALSA/ && \
	LDFLAGS="$LDFLAGS -ldl" ./configure --prefix=/usr --with-versioned --enable-shared \
	--disable-static --disable-python && make && make install && \
	rm -rf /usr/src/alsa-lib-$VER_LIBALSA

ARG VER_ODBC=2.3.7
ADD downloads/unixODBC-$VER_ODBC.tar.gz /usr/src
RUN \
    cd /usr/src/unixODBC-$VER_ODBC && \
    ./configure --prefix=/usr --sysconfdir=/etc --enable-inicaching \
    --disable-readline --enable-setlibversion \
    --enable-shared --disable-static && \
    make && make install && rm -rf /usr/src/unixODBC-$VER_ODBC

ARG VER_PORTAUDIO=v190600_20161030
ADD downloads/pa_stable_$VER_PORTAUDIO.tgz /usr/src
RUN \
    cd /usr/src/portaudio && CFLAGS="$CFLAGS -fvisibility=hidden" ./configure --prefix=/usr \
    --with-alsa --with-pic --enable-static --disable-shared && \
    make && make install && rm -rf /usr/src/portaudio

ARG VER_OPUS=1.3
ADD downloads/opus-$VER_OPUS.tar.gz /usr/src
RUN \
    cd /usr/src/opus-$VER_OPUS && CFLAGS="$CFLAGS -fvisibility=hidden" \
    ./configure --enable-fixed-point --prefix=/usr --disable-rtcd \
    --disable-extra-programs --enable-static --disable-shared --disable-doc && \
    make && make install && \
   rm -rf /usr/src/opus-$VER_OPUS

ARG VER_PG=12.0
ADD downloads/postgresql-$VER_PG.tar.gz /usr/src
RUN \
    cd /usr/src/postgresql-$VER_PG && \
        ./configure --without-gssapi --without-readline \
        --with-openssl --prefix=/usr --sysconfdir=/etc \
	    LDFLAGS="$LDFLAGS -pthread" && \
        make -C src/interfaces/libpq install && \
        make -C src/bin/pg_config install && \
        make -C src/backend generated-headers && \
        make -C src/include install && \
    rm -rf /usr/src/postgresql-$VER_PG

ARG VER_PGODBC=12.00.0000
ADD downloads/psqlodbc-$VER_PGODBC.tar.gz /usr/src
RUN cd /usr/src/psqlodbc-$VER_PGODBC && \
    ( ./configure --prefix=/usr --sysconfdir=/etc LDFLAGS="$LDFLAGS -pthread" && \
    make && make install && rm -rf /usr/src/postgresql-$VER_PG ) || \
    ( cat config.log ; exit 1)

ARG VER_LIBIDN=1.11
ADD downloads/libidn-$VER_LIBIDN.tar.gz /usr/src
RUN \
    cd /usr/src/libidn-$VER_LIBIDN && \
        ./configure --prefix=/usr -enable-static --enable-shared  && \
        make && make install && \
        rm -rf /usr/src/libidn-$VER_LIBIDN

ARG VER_CMAKE=3.1.3
ARG CMAKE_ARCH=$UNAME_ARCH
ADD downloads/cmake-$VER_CMAKE-Linux-$CMAKE_ARCH.tar.gz /usr/src
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
    mv -f libmariadb/include/ma_context.h_ libmariadb/include/ma_context.h && \
    cmake -DCONC_WITH_UNIT_TESTS=Off -DWITH_SSL=OPENSSL -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr . && make maodbc && cp -vf libmaodbc.so /usr/lib/ && \
    rm -rf /usr/src/mariadb-connector-odbc-$VER_MARIADBODBC-ga-src

RUN \
    rm -rf /usr/share/locale /usr/share/man /usr/share/info

RUN \
    cd /usr/lib/python$PYTHON_ABI && \
    find -name "*.so" | while read f; do strip $f; done && \
    rm -rf /usr/src && ldconfig && \
    apt-get clean

RUN mkdir -p /build/workspace/project

RUN \
    find / -noleaf -xdev ! -uid 0 -or ! -gid 0 -exec chown 0:0 '{}' ';'

ENV PATH $PATH:/build/workspace/project:/build/workspace/.local/bin
ENV WORKSPACE /build/workspace
ENV PROJECT /build/workspace/project
ENV TOOLCHAIN_ARCH=$ARCH
ENV TOOLCHAIN_DIST=$DIST
ENV PYMAJ=$PYTHON_MAJ
ENV PYMIN=$PYTHON_MIN

WORKDIR /build/workspace/project
VOLUME /build/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.1"
LABEL description="Toolchain with python$PYTHON_ABI and not-so-new 64bit ABI"
