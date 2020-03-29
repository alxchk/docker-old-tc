#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE32
export VCINSTALLDIR="C:\\Program Files\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\VC"
export WindowsSdkDir="C:\\Program Files\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\WinSDK"
export INCLUDE="$VCINSTALLDIR\\Include;$WindowsSdkDir\\Include"
export LIB="$VCINSTALLDIR\\Lib;$WindowsSdkDir\\Lib"
export LIBPATH="$VCINSTALLDIR\\Lib;$WindowsSdkDir\\Lib"
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/nologo /GL /GS-"
exec wine "$VCINSTALLDIR\\bin\\cl.exe" "$@"
