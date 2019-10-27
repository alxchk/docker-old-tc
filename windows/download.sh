#!/bin/bash

PYVER=2.7.17
SELF=`readlink -f "$0"`
DOWNLOADS=`dirname "$0"`/downloads

PYTHON64="https://www.python.org/ftp/python/$PYVER/python-$PYVER.amd64.msi"
PYTHON32="https://www.python.org/ftp/python/$PYVER/python-$PYVER.msi"
PERL32="http://strawberryperl.com/download/5.28.1.1/strawberry-perl-5.28.1.1-32bit.msi"
PERL64="http://strawberryperl.com/download/5.28.1.1/strawberry-perl-5.28.1.1-64bit.msi"
NASM32="https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/win32/nasm-2.14.02-win32.zip"
NASM64="https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/win64/nasm-2.14.02-win64.zip"
PYTHONVC="https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi"
WINETRICKS="https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"
OPENSSL="https://www.openssl.org/source/openssl-1.0.2t.tar.gz"
STDINT="https://raw.githubusercontent.com/mattn/gntp-send/master/include/msinttypes/stdint.h"

mkdir -p $DOWNLOADS

for dist in $PYTHON32 $PYTHON64 $PYTHONVC $WINETRICKS $PERL32 $PERL64 $OPENSSL $NASM32 $NASM64 $STDINT; do
    wget -qcP $DOWNLOADS $dist
done
