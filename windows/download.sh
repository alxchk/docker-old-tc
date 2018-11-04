#!/bin/bash

PYVER=2.7.15
SELF=`readlink -f "$0"`
DOWNLOADS=`dirname "$0"`/downloads

PYTHON64="https://www.python.org/ftp/python/$PYVER/python-$PYVER.amd64.msi"
PYTHON32="https://www.python.org/ftp/python/$PYVER/python-$PYVER.msi"
PYTHONVC="https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi"
WINETRICKS="https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"

mkdir -p $DOWNLOADS

for dist in $PYTHON32 $PYTHON64 $PYTHONVC $WINETRICKS; do
    wget -qcP $DOWNLOADS $dist
done
