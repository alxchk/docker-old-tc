#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE64
export VCINSTALLDIR="C:\\Program Files (x86)\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\VC"
export WindowsSdkDir="C:\\Program Files (x86)\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\WinSDK"
export INCLUDE="$VCINSTALLDIR\\Include;$WindowsSdkDir\\Include"
export LIB="$VCINSTALLDIR\\Lib\\amd64;$WindowsSdkDir\\Lib\\x64"
export LIBPATH="$VCINSTALLDIR\\Lib\\amd64;$WindowsSdkDir\\Lib\\x64"
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/nologo /GL /GS-"
exec wine "$VCINSTALLDIR\\bin\\amd64\\cl.exe" "$@"
