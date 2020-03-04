#!/bin/bash

OPENSSL_VER=1.0.2t
ZLIB_VER=1.2.11
BZIP_VER=1.0.6
SQLITE_VER=3300100
SQLITE_YEAR=2019
PYTHON_VER=2.7.17
KRB5_VER=1.17-final
ODBC_VER=2.3.7
PG_VER=12.0
PGODBC_VER=12.00.0000
MARIADBODBC_VER=3.1.6

# VERSIONS /MAY/ BE UPDATED (In case of vulnerabilites)
OPENSSL_SRC="https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz"
ZLIB_SRC="http://zlib.net/zlib-$ZLIB_VER.tar.gz"
BZIP_SRC="http://http.debian.net/debian/pool/main/b/bzip2/bzip2_$BZIP_VER.orig.tar.bz2"
SQLITE_SRC="http://www.sqlite.org/$SQLITE_YEAR/sqlite-autoconf-$SQLITE_VER.tar.gz"
PYTHON_SRC="https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz"
KRB5_SRC="https://github.com/krb5/krb5/archive/krb5-${KRB5_VER}.tar.gz"
ODBC_SRC="http://www.unixodbc.org/unixODBC-${ODBC_VER}.tar.gz"
PG_SRC="https://ftp.postgresql.org/pub/source/v$PG_VER/postgresql-$PG_VER.tar.gz"
PGODBC_SRC="https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-$PGODBC_VER.tar.gz"
MYSQLC_SRC="https://downloads.mariadb.com/Connectors/c/connector-c-$MARIADBODBC_VER/mariadb-connector-c-$MARIADBODBC_VER-src.tar.gz"
MYSQLODBC_SRC="https://downloads.mariadb.org/interstitial/connector-$MARIADBODBC_VER/mariadb-connector-odbc-$MARIADBODBC_VER-ga-src.tar.gz"

# VERSIONS ARE ENOUGH
LIBACL_SRC="http://download.savannah.gnu.org/releases/acl/acl-2.2.53.tar.gz"
LIBCAP_SRC="https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.gz"
LIBATTR_SRC="http://download.savannah.gnu.org/releases/attr/attr-2.4.48.tar.gz"
LIBFFI_SRC="http://http.debian.net/debian/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz"
PKGCONFIG_SRC="https://pkg-config.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
M4_SRC="https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz"
AUTOCONF_SRC="https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
AUTOMAKE_SRC="https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz"
PORTAUDIO_SRC="http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz"
OPUS_SRC="https://archive.mozilla.org/pub/opus/opus-1.3.tar.gz"
LIBIDN_SRC="https://ftp.gnu.org/gnu/libidn/libidn-1.11.tar.gz"

# VERSIONS ARE IMPORTANT
MAKE_SRC="http://ftp.gnu.org/gnu/make/make-3.82.tar.gz"
GLIB_SRC="https://ftp.gnome.org/pub/gnome/sources/glib/2.32/glib-2.32.4.tar.xz"
DBUS_SRC="https://dbus.freedesktop.org/releases/dbus/dbus-1.2.12.tar.gz"
DBUS_GLIB_SRC="https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.88.tar.gz"
GOBJECT_INTROSPECTION="http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.32/gobject-introspection-1.32.1.tar.xz"
PYGOBJECT="http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.2/pygobject-3.2.2.tar.xz"
DBUS_PYTHON="https://dbus.freedesktop.org/releases/dbus-python/dbus-python-0.84.0.tar.gz"

# ENV
SELF=$(readlink -f "$0")
DOWNLOADS=$(dirname "$SELF")/downloads

mkdir -p $DOWNLOADS
cd $DOWNLOADS
for bin in "$MAKE_SRC" "$OPENSSL_SRC" "$ZLIB_SRC" "$BZIP_SRC" "$SQLITE_SRC" "$LIBFFI_SRC" \
    "$PYTHON_SRC" "$PKGCONFIG_SRC" "$GLIB_SRC" "$LIBACL_SRC" "$LIBATTR_SRC" \
    "$LIBCAP_SRC" "$DBUS_SRC" "$DBUS_GLIB_SRC" "$GOBJECT_INTROSPECTION" \
    "$PYGOBJECT" "$DBUS_PYTHON" "$M4_SRC" "$AUTOCONF_SRC" \
    "$PORTAUDIO_SRC" "$OPUS_SRC" "$AUTOMAKE_SRC" "$KRB5_SRC" "$ODBC_SRC" \
    "$PG_SRC" "$PGODBC_SRC" "$MYSQLC_SRC" "$MYSQLODBC_SRC" "$LIBIDN_SRC"; do
    wget -qc "$bin" || (echo "Failed to download $bin"; exit 1)
done
