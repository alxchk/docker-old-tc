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
RC="$BUILDENV/rc-with-includes"
PYTHON_VER=2.7.16
OPENSSL_VER="1.0.2r"
NASM_VER="2.14.02"

MINGW64=${MINGW64:-x86_64-w64-mingw32-g++}
MINGW32=${MINGW32:-i686-w64-mingw32-g++}

exec < /dev/null

mkdir -p "$BUILDENV"

WINEARCH=win32 WINEPREFIX=$WINE32 wineboot
WINEARCH=win64 WINEPREFIX=$WINE64 wineboot

for prefix in $WINE32 $WINE64; do
    rm -f $prefix/dosdevices/y:
    ln -sf $DOWNLOADS $prefix/dosdevices/y:
    rm -f $prefix/dosdevices/x:
    ln -sf $RC $prefix/dosdevices/x:
done

WINEPREFIX=$WINE32 wineserver -k || true

WINEPREFIX=$WINE32 msiexec /i Y:\\python-$PYTHON_VER.msi /q
WINEPREFIX=$WINE64 msiexec /i Y:\\python-$PYTHON_VER.amd64.msi /q

WINEPREFIX=$WINE32 msiexec /i Y:\\strawberry-perl-5.28.1.1-32bit.msi /q
WINEPREFIX=$WINE64 msiexec /i Y:\\strawberry-perl-5.28.1.1-64bit.msi /q

for prefix in $WINE32 $WINE64; do
    WINEPREFIX=$prefix msiexec /i Y:\\VCForPython27.msi /q
    WINEPREFIX=$prefix wineboot -r
    WINEPREFIX=$prefix wineserver -k

    rm -rf $prefix/drive_c/Strawberry/c
done

cd $WINE32/drive_c && unzip $DOWNLOADS/nasm-${NASM_VER}-win32.zip && mv nasm-${NASM_VER} nasm
cd $WINE64/drive_c && unzip $DOWNLOADS/nasm-${NASM_VER}-win64.zip && mv nasm-${NASM_VER} nasm

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

cat >$WINE32/nmake.sh <<EOF
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
export WINEPATH="C:\\\\Windows;C:\\\\nasm;\$VCINSTALLDIR\\\\bin;X:\\\\"
exec wine "\$VCINSTALLDIR\\\\bin\\\\nmake.exe" "\$@"
EOF
chmod +x $WINE32/nmake.sh

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

cat >$WINE64/nmake.sh <<EOF
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
export WINEPATH="C:\\\\Windows;C:\\\\nasm;\$VCINSTALLDIR\\\\bin\\\\amd64;\$VCINSTALLDIR\\\\bin;X:\\\\"
exec wine "\$VCINSTALLDIR\\\\bin\\\\amd64\\\\nmake.exe" "\$@"
EOF
chmod +x $WINE64/nmake.sh
