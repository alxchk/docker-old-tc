#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE32
export VCINSTALLDIR="C:\\Program Files\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\VC"
export WindowsSdkDir="C:\\Program Files\\Common Files\\Microsoft\\Visual C++ for Python\\9.0\\WinSDK"
export INCLUDE="$VCINSTALLDIR\\Include;$WindowsSdkDir\\Include"
export LIB="$VCINSTALLDIR\\Lib;$WindowsSdkDir\\Lib"
export LIBPATH="$VCINSTALLDIR\\Lib;$WindowsSdkDir\\Lib"
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/GL /GS-"
export WINEPATH="$WINEPATH;$VCINSTALLDIR\\bin;$WindowsSdkDir\\Bin;X:\\rc\\32bit"
exec wine cmd "$@"
