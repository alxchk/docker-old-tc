#!/bin/sh

unset WINEARCH WINEPREFIX

set -xe

SELF=`readlink -f $0`
CWD=`dirname $0`

BUILDENV=/build

WINE=${WINE:-wine}
WINE32="$BUILDENV/win32"
WINE64="$BUILDENV/win64"
DOWNLOADS="$BUILDENV/downloads"

MINGW64=${MINGW64:-x86_64-w64-mingw32-g++}
MINGW32=${MINGW32:-i686-w64-mingw32-g++}

exec < /dev/null

mkdir -p "$BUILDENV"
mkdir -p "$DOWNLOADS"

WINEARCH=win32 WINEPREFIX=$WINE32 wineboot
WINEARCH=win64 WINEPREFIX=$WINE64 wineboot

for prefix in $WINE32 $WINE64; do
    rm -f $prefix/dosdevices/y:
    ln -sf $DOWNLOADS $prefix/dosdevices/y:
done

WINEPREFIX=$WINE32 wineserver -k || true

[ ! -f $WINE32/drive_c/.python ] && \
    WINEPREFIX=$WINE32 msiexec /i Y:\\python-$PYVER.msi /q && \
    touch $WINE32/drive_c/.python

WINEPREFIX=$WINE32 wineboot -r
WINEPREFIX=$WINE32 wineserver -k  || true

[ ! -f $WINE64/drive_c/.python ] && \
    WINEPREFIX=$WINE64 msiexec /i Y:\\python-$PYVER.amd64.msi /q && \
    touch $WINE64/drive_c/.python

WINEPREFIX=$WINE64 wineboot -r
WINEPREFIX=$WINE64 wineserver -k || true

for prefix in $WINE32 $WINE64; do
    [ ! -f $prefix/drive_c/.vc ] && \
	WINEPREFIX=$prefix msiexec /i Y:\\VCForPython27.msi /q && \
	touch $prefix/drive_c/.vc
done

WINEPREFIX=$WINE32 sh $DOWNLOADS/winetricks winxp
WINEPREFIX=$WINE64 sh $DOWNLOADS/winetricks win7

WINEPREFIX=$WINE32 wine reg add 'HKCU\Software\Wine\DllOverrides' /t REG_SZ /v dbghelp /d '' /f

export WINEPREFIX=$WINE64

mkdir -p $WINE64/drive_c/windows/Microsoft.NET/Framework
mkdir -p $WINE64/drive_c/windows/Microsoft.NET/Framework64

touch $WINE64/drive_c/windows/Microsoft.NET/Framework/empty.txt
touch $WINE64/drive_c/windows/Microsoft.NET/Framework64/empty.txt

wine reg add 'HKCU\Software\Wine\DllOverrides' /t REG_SZ /v dbghelp /d '' /f

wine reg add \
     'HKCU\Software\Microsoft\DevDiv\VCForPython\9.0' \
     /t REG_SZ /v installdir \
     /d 'C:\Program Files (x86)\Common Files\Microsoft\Visual C++ for Python\9.0' \
     /f

wineboot -fr
wineserver -k || true

unset WINEPREFIX

for prefix in $WINE32 $WINE64; do
    WINEPREFIX=$prefix wine C:\\Python27\\python -m pip install -q --upgrade pip
    WINEPREFIX=$prefix wine C:\\Python27\\python -m pip install -q --upgrade setuptools
    WINEPREFIX=$prefix wine C:\\Python27\\python -m pip install -q pycparser==2.17
done

cat >$WINE32/python.sh <<EOF
#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE32
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/O1 /GL /GS-"
exec wine C:\\\\Python27\\\\python.exe "\$@"
EOF
chmod +x $WINE32/python.sh

cat >$WINE32/cl.sh <<EOF
#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE32
export VCINSTALLDIR="C:\\\\Program Files\\\\Common Files\\\\Microsoft\\\\Visual C++ for Python\\\\9.0\\\\VC"
export WindowsSdkDir="C:\\\\Program Files\\\\Common Files\\\\Microsoft\\\\Visual C++ for Python\\\\9.0\\\\WinSDK"
export INCLUDE="\$VCINSTALLDIR\\\\Include;\$WindowsSdkDir\\\\Include"
export LIB="\$VCINSTALLDIR\\\\Lib;\$WindowsSdkDir\\\\Lib"
export LIBPATH="\$VCINSTALLDIR\\\\Lib;\$WindowsSdkDir\\\\Lib"
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/GL /GS-"
exec wine "\$VCINSTALLDIR\\\\bin\\\\cl.exe" "\$@"
EOF
chmod +x $WINE32/cl.sh

cat >$WINE64/python.sh <<EOF
#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE64
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/O1 /GL /GS-"
exec wine C:\\\\Python27\\\\python.exe "\$@"
EOF
chmod +x $WINE64/python.sh

cat >$WINE64/cl.sh <<EOF
#!/bin/sh
unset WINEARCH
export WINEPREFIX=$WINE64
export VCINSTALLDIR="C:\\\\Program Files (x86)\\\\Common Files\\\\Microsoft\\\\Visual C++ for Python\\\\9.0\\\\VC"
export WindowsSdkDir="C:\\\\Program Files (x86)\\\\Common Files\\\\Microsoft\\\\Visual C++ for Python\\\\9.0\\\\WinSDK"
export INCLUDE="\$VCINSTALLDIR\\\\Include;\$WindowsSdkDir\\\\Include"
export LIB="\$VCINSTALLDIR\\\\Lib\\\\amd64;\$WindowsSdkDir\\\\Lib\\\\x64"
export LIBPATH="\$VCINSTALLDIR\\\\Lib\\\\amd64;\$WindowsSdkDir\\\\Lib\\\\x64"
export LINK="/NXCOMPAT:NO /LTCG"
export CL="/GL /GS-"
exec wine "\$VCINSTALLDIR\\\\bin\\\\amd64\\\\cl.exe" "\$@"
EOF
chmod +x $WINE64/cl.sh
