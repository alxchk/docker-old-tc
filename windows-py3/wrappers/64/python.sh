#!/bin/sh
export MSVCARCH=64

export LINK="/nologo /NXCOMPAT:NO /LTCG"
export CL="/O1 /nologo /GL /GS-"
export DISTUTILS_USE_SDK=yes

exec vcwine C:\\Python3-64\\python.exe "$@"
