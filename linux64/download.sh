#!/bin/bash

OPENSSL_VER=1.0.2o
ZLIB_VER=1.2.11
SQLITE_VER=3230100
SQLITE_YEAR=2018
PYTHON_VER=2.7.15

# VERSIONS /MAY/ BE UPDATED (In case of vulnerabilites)
OPENSSL_SRC="https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz"
ZLIB_SRC="http://zlib.net/zlib-$ZLIB_VER.tar.gz"
SQLITE_SRC="http://www.sqlite.org/$SQLITE_YEAR/sqlite-autoconf-$SQLITE_VER.tar.gz"
PYTHON_SRC="https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz"

# VERSIONS ARE ENOUGH
LIBFFI_SRC="http://http.debian.net/debian/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz"
PKGCONFIG_SRC="https://pkg-config.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
M4_SRC="https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz"
AUTOCONF_SRC="https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
AUTOMAKE_SRC="https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz"

# VERSIONS ARE IMPORTANT
MAKE_SRC="http://ftp.gnu.org/gnu/make/make-3.82.tar.gz"
GLIB_SRC="https://ftp.gnome.org/pub/gnome/sources/glib/2.32/glib-2.32.4.tar.xz"
DBUS_SRC="https://dbus.freedesktop.org/releases/dbus/dbus-1.2.12.tar.gz"
DBUS_GLIB_SRC="https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.88.tar.gz"
GOBJECT_INTROSPECTION="http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.32/gobject-introspection-1.32.1.tar.xz"
PYGOBJECT="http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.2/pygobject-3.2.2.tar.xz"
DBUS_PYTHON="https://dbus.freedesktop.org/releases/dbus-python/dbus-python-0.84.0.tar.gz"

# ENV
SELF=`readlink -f "$0"`
DOWNLOADS=`dirname "$SELF"`/downloads

mkdir -p $DOWNLOADS
cd $DOWNLOADS
for bin in "$MAKE_SRC" "$OPENSSL_SRC" "$ZLIB_SRC" "$SQLITE_SRC" "$LIBFFI_SRC" \
                       "$PYTHON_SRC" "$PKGCONFIG_SRC" "$GLIB_SRC" \
                       "$DBUS_SRC" "$DBUS_GLIB_SRC" "$GOBJECT_INTROSPECTION" \
                       "$PYGOBJECT" "$DBUS_PYTHON" "$M4_SRC" "$AUTOCONF_SRC" \
		   "$AUTOMAKE_SRC" ; do
    wget -qc "$bin" || exit 1
done
