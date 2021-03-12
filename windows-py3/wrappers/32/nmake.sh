#!/bin/sh
export MSVCARCH=32

export LINK="/nologo /NXCOMPAT:NO /LTCG"
export CL="/nologo /GL /GS-"
export DISTUTILS_USE_SDK=yes

exec vcwine nmake.exe "$@"
