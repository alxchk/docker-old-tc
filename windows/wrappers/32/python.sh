#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE32
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/O1 /GL /GS-"
exec wine C:\\Python27\\python.exe "$@"
