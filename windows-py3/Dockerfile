ARG NAMESPACE=
FROM ${NAMESPACE}msvc-slim:15

LABEL maintainer "alxchk@gmail.com"

ARG BUILDENV="/build"
ARG DOWNLOADS="${BUILDENV}/downloads"
ARG WINE32="MSVCARCH=32 vcwine"
ARG WINE64="MSVCARCH=64 vcwine"

RUN yes | (pip install setuptools; CC=gcc python3 -m pip install pylzma)

ENV \
    DOS_DOWNLOADS="y:" \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++ \
    WINE32=$WINE32 \
    WINE64=$WINE64 \
    DOWNLOADS=${DOWNLOADS} \
    BUILDENV=${BUILDENV}

COPY \
    wrappers/xvfb-run /usr/bin/xvfb-run

RUN \
    rm -vf $WINEPREFIX/dosdevices/$DOS_DOWNLOADS && \
    ln -Tnvs $DOWNLOADS $WINEPREFIX/dosdevices/$DOS_DOWNLOADS && \
    chmod +x /usr/bin/xvfb-run 

ARG PYTHON_MAJ=3
ARG PYTHON_MIN=8
ARG PYTHON_REV=6
ARG PYTHON_ABI=$PYTHON_MAJ.$PYTHON_MIN
ARG VER_PYTHON=$PYTHON_MAJ.$PYTHON_MIN.$PYTHON_REV

ENV \
    PYTHON_ABI=$PYTHON_ABI \
    VER_PYTHON=$VER_PYTHON

COPY \
    downloads/python-${VER_PYTHON}.exe \
    downloads/python-${VER_PYTHON}-amd64.exe $DOWNLOADS/

RUN \
    wineboot -u && \
    echo "Install python 32" && \
    xvfb-run wine $DOWNLOADS/python-${VER_PYTHON}.exe /quiet \
    	     InstallAllUsers=1 TargetDir=C:\\Python3-32 CompileAll=0 CRTInstalled=0 \
	     Include_doc=0 Include_tcltk=0 Include_test=0 && \
    echo "Install python 64" && \
    xvfb-run wine $DOWNLOADS/python-${VER_PYTHON}-amd64.exe /quiet \
    	     InstallAllUsers=1 TargetDir=C:\\Python3-64 CompileAll=0 CRTInstalled=0 \
	     Include_doc=0 Include_tcltk=0 Include_test && \
    echo "Cleanup installs" && \
    rm -f ${DOWNLOADS}/python-${VER_PYTHON}.msi ${DOWNLOADS}/python-${VER_PYTHON}-amd64.msi && \
    echo "Update registry" && \
    wine reg \
        add "HKCU\\Software\\Wine\\DllOverrides" /t REG_SZ /v dbghelp /d '' /f && \
    echo "Shutdown" && \
    wineboot -e && wineboot -f && wineboot -s

RUN \
    rm -rf $DOWNLOADS && \
    find \
        $WINEPREFIX/drive_c/windows \
        $WINEPREFIX/drive_c/users \
        \( -iname "*t?mp*" -or -iname "*cache*" \) | xargs rm -rf && \
    mkdir -p $WINEPREFIX/drive_c/users/root/Temp $WINEPREFIX/drive_c/windows/Temp && \
    rm -rf $WINEPREFIX/drive_c/windows/assembly

COPY wrappers/32 /opt/32
COPY wrappers/64 /opt/64

ENV \
    PYMAJ=$PYTHON_MAJ \
    PYMIN=$PYTHON_MIN \
    PYTHON32=/opt/32/python.sh \
    PYTHON64=/opt/64/python.sh \
    WINE_PYTHONPATH32=C:\\Python3-32 \
    WINE_PYTHONPATH64=C:\\Python3-64 \
    PYTHONPATH32=/opt/win/drive_c/Python3-32 \
    PYTHONPATH64=/opt/win/drive_c/Python3-64 \
    CL32=/opt/32/cl.sh \
    CL64=/opt/64/cl.sh \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++ \
    WINEDEBUG="-all" \
    PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:${BUILDENV}/workspace/project:${BUILDENV}/workspace/.local/bin \
    WORKSPACE=${BUILDENV}/workspace \
    PROJECT=${BUILDENV}/workspace/project

WORKDIR ${BUILDENV}/workspace/project
VOLUME ${BUILDENV}/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.1"
LABEL description="Toolchain with wine (32/64) MSVC CL, MinGW and Python3"

ENTRYPOINT []
