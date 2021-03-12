#!/bin/sh
export MSVCARCH=64

export LINK="/nologo /NXCOMPAT:NO /LTCG"
export CL="/nologo /GL /GS-"

exec vcwine "cl.exe" "$@"
