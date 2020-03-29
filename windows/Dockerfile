FROM debian:buster-slim

LABEL maintainer "alxchk@gmail.com"

ARG BUILDENV="/build"
ARG RCDIR="${BUILDENV}/rc-with-includes"
ARG DOWNLOADS="${BUILDENV}/downloads"
ARG WINE32="${BUILDENV}/win32"
ARG WINE64="${BUILDENV}/win64"

ENV \
    DEBIAN_FRONTEND=noninteractive

USER 0:0

RUN dpkg --add-architecture i386 && apt-get update && apt-get upgrade -y && \
    apt-get -y install --no-install-recommends apt-utils \
    mingw-w64 g++-mingw-w64-x86-64 g++-mingw-w64-i686 \
    debootstrap python python-pip git make wine wine64 wine32 xvfb \
    python-setuptools-git build-essential python-dev python-wheel \
    xauth xxd zip unzip automake && apt-get clean

RUN yes | pip install pylzma

ENV \
    WINEDEBUG="-all" \
    WINE=${WINE:-wine} \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++ \
    DOS_DOWNLOADS="y:" \
    DOS_RC="x:" \
    WINE32=${WINE32} \
    WINE64=${WINE64} \
    RCDIR=${RCDIR} \
    DOWNLOADS=${DOWNLOADS} \
    BUILDENV=${BUILDENV}

RUN \
    mkdir -p $BUILDENV/workspace/project && \
    WINEARCH=win32 WINEPREFIX=${WINE32} wineboot -u && \
    WINEARCH=win64 WINEPREFIX=${WINE64} wineboot -u && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s

RUN \
    rm -vf $WINE32/dosdevices/$DOS_DOWNLOADS && \
    rm -vf $WINE64/dosdevices/$DOS_DOWNLOADS && \
    rm -vf $WINE32/dosdevices/$DOS_RC && \
    rm -vf $WINE64/dosdevices/$DOS_RC && \
    ln -Tnvs $DOWNLOADS $WINE32/dosdevices/$DOS_DOWNLOADS && \
    ln -Tnvs $DOWNLOADS $WINE64/dosdevices/$DOS_DOWNLOADS && \
    ln -Tnvs ${RCDIR} $WINE32/dosdevices/$DOS_RC && \
    ln -Tnvs ${RCDIR} $WINE64/dosdevices/$DOS_RC

ARG NASM_VER=2.14.02

COPY \
    downloads/nasm-${NASM_VER}-win32.zip \
    downloads/nasm-${NASM_VER}-win64.zip \
        ${DOWNLOADS}/

RUN \
    cd ${WINE32}/drive_c && unzip ${DOWNLOADS}/nasm-${NASM_VER}-win32.zip && \
    cd ${WINE64}/drive_c && unzip ${DOWNLOADS}/nasm-${NASM_VER}-win64.zip && \
        rm -f ${DOWNLOADS}/nasm-${NASM_VER}-win32.zip && \
        rm -f ${DOWNLOADS}/nasm-${NASM_VER}-win64.zip

COPY \
    rc-with-includes ${RCDIR}

ARG PERL_VER=5.28.1.1
ARG PYTHON_VER=2.7.17

COPY \
    downloads/VCForPython27.msi \
    downloads/winetricks \
    downloads/python-${PYTHON_VER}.msi \
    downloads/python-${PYTHON_VER}.amd64.msi \
    downloads/strawberry-perl-${PERL_VER}-32bit.msi \
    downloads/strawberry-perl-${PERL_VER}-64bit.msi ${DOWNLOADS}/

RUN \
    WINEPREFIX=${WINE32} wineboot -u && \
    WINEPREFIX=${WINE64} wineboot -u && \
    WINEPREFIX=$WINE32 msiexec /i ${DOS_DOWNLOADS}\\strawberry-perl-${PERL_VER}-32bit.msi /q && \
    WINEPREFIX=$WINE64 msiexec /i ${DOS_DOWNLOADS}\\strawberry-perl-${PERL_VER}-64bit.msi /q && \
    WINEPREFIX=$WINE32 msiexec /i $DOS_DOWNLOADS\\python-$PYTHON_VER.msi /q && \
    WINEPREFIX=$WINE64 msiexec /i $DOS_DOWNLOADS\\python-$PYTHON_VER.amd64.msi /q && \
    WINEPREFIX=$WINE32 msiexec /i $DOS_DOWNLOADS\\VCForPython27.msi /q && \
    WINEPREFIX=$WINE64 msiexec /i $DOS_DOWNLOADS\\VCForPython27.msi /q && \
        rm -f ${DOWNLOADS}/python-${PYTHON_VER}.msi \
            ${DOWNLOADS}/python-${PYTHON_VER}.amd64.msi && \
    WINEPREFIX=${WINE32} sh ${DOWNLOADS}/winetricks winxp && \
    WINEPREFIX=${WINE64} sh ${DOWNLOADS}/winetricks win7 &&  \
    WINEPREFIX=${WINE32} wine reg \
        add "HKCU\\Software\\Wine\\DllOverrides" /t REG_SZ /v dbghelp /d '' /f && \
    WINEPREFIX=${WINE64} wine reg \
        add "HKCU\\Software\\Wine\\DllOverrides" /t REG_SZ /v dbghelp /d '' /f && \
    WINEPREFIX=${WINE64} wine reg \
         add "HKCU\\Software\\Microsoft\\DevDiv\\VCForPython\\9.0" \
         /t REG_SZ /v installdir \
         /d "C:\\Program Files (x86)\\Common Files\\Microsoft\\Visual C++ for Python\\9.0" \
         /f && \
    mkdir -p ${WINE64}/drive_c/windows/Microsoft.NET/Framework && \
    mkdir -p ${WINE64}/drive_c/windows/Microsoft.NET/Framework64 && \
    touch ${WINE64}/drive_c/windows/Microsoft.NET/Framework/empty.txt && \
    touch ${WINE64}/drive_c/windows/Microsoft.NET/Framework64/empty.txt && \
    rm -f ${DOWNLOADS}/winetricks && \
    rm -f ${DOWNLOADS}/VCForPython27.msi && \
    rm -f  ${DOWNLOADS}/strawberry-perl-${PERL_VER}-32bit.msi \
        ${DOWNLOADS}/strawberry-perl-${PERL_VER}-64bit.msi && \
    WINEPREFIX=${WINE32} wineboot -e && \
    WINEPREFIX=${WINE64} wineboot -e && \
    WINEPREFIX=${WINE32} wineboot -f && \
    WINEPREFIX=${WINE64} wineboot -f && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s

COPY wrappers/32 ${WINE32}
COPY wrappers/64 ${WINE64}

ARG OPENSSL_VER=1.1.1d
ENV OPENSSL_ABI_VER=1_1

ARG OPENSSL_OPTIONS="shared no-async enable-static-engine no-autoload-config no-cms no-hw no-ssl2 enable-weak-ssl-ciphers no-unit-test no-filenames no-gost no-sctp no-srp no-tests no-ts no-dtls no-dtls1 no-dtls1_2 no-err no-ui"

ENV WINEPATH="C:\\nasm-${NASM_VER};C:\\Python27;C:\\Python27\\Scripts;C:\\Strawberry\\perl\\bin"

ADD \
    downloads/openssl-${OPENSSL_VER}.tar.gz ${BUILDENV}

RUN \
    cd ${BUILDENV}/openssl-${OPENSSL_VER} && \
    sed -e 's@/Zi[^"]*@@;s@/debug@@g;' -i Configurations/10-main.conf && \
    sed -e 's@|| (DEL /Q \\$(\\\@B).\* $import && EXIT 1)@@g' -i \
        Configurations/windows-makefile.tmpl && \
    MT=echo ${WINE64}/perl.sh Configure VC-WIN64A \
        --prefix=C:\\openssl-build --release $OPENSSL_OPTIONS \
            CFLAGS="/nologo /GL /Os /GF /Gy /GA" \
            LDFLAGS="/nologo /OPT:REF /OPT:ICF /LTCG" && \
    ${WINE64}/nmake.sh build_libs && \
    touch libcrypto-${OPENSSL_ABI_VER}-x64.pdb && \
    touch libssl-${OPENSSL_ABI_VER}-x64.pdb && \
    ${WINE64}/nmake.sh install_dev && \
    rm -rf ${BUILDENV}/openssl-${OPENSSL_VER} && \
    cp -vr ${WINE64}/drive_c/openssl-build/include/openssl ${WINE64}/drive_c/Python27/include/ && \
    cp -v ${WINE64}/drive_c/openssl-build/bin/*.dll ${WINE64}/drive_c/Python27 && \
    cp -v ${WINE64}/drive_c/openssl-build/lib/*.lib ${WINE64}/drive_c/Python27/libs && \
    rm -rf ${WINE64}/drive_c/openssl-build

ADD \
    downloads/openssl-${OPENSSL_VER}.tar.gz ${BUILDENV}

RUN \
    cd ${BUILDENV}/openssl-${OPENSSL_VER} && \
    sed -e 's@/Zi[^"]*@@;s@/debug@@g;' -i Configurations/10-main.conf && \
    sed -e 's@|| (DEL /Q \\$(\\\@B).\* $import && EXIT 1)@@g' -i \
        Configurations/windows-makefile.tmpl && \
    MT=echo ${WINE32}/perl.sh Configure VC-WIN32 \
        --prefix=C:\\openssl-build --release $OPENSSL_OPTIONS \
            CFLAGS="/nologo /GL /Os /GF /Gy /GA" \
            LDFLAGS="/nologo /OPT:REF /OPT:ICF /LTCG" && \
    ${WINE32}/nmake.sh build_libs && \
    touch libcrypto-${OPENSSL_ABI_VER}.pdb && \
    touch libssl-${OPENSSL_ABI_VER}.pdb && \
    ${WINE32}/nmake.sh install_dev && \
    rm -rf ${BUILDENV}/openssl-${OPENSSL_VER} && \
    cp -vr ${WINE32}/drive_c/openssl-build/include/openssl ${WINE32}/drive_c/Python27/include/ && \
    cp -v ${WINE32}/drive_c/openssl-build/bin/*.dll ${WINE32}/drive_c/Python27 && \
    cp -v ${WINE32}/drive_c/openssl-build/lib/*.lib ${WINE32}/drive_c/Python27/libs && \
    rm -rf ${WINE32}/drive_c/openssl-build

COPY \
    modules/_ssl.c modules/_ssl_data.h modules/socketmodule.h \
        ${BUILDENV}/ssl/

RUN \
    cd ${BUILDENV}/ssl && \
    ${WINE32}/cl.sh \
        _ssl.c \
        /LD /D_WIN32 /IC:\\Python27\\Include \
        C:\\Python27\\libs\\python27.lib \
        C:\\Python27\\libs\\libcrypto.lib \
        C:\\Python27\\libs\\libssl.lib \
        advapi32.lib crypt32.lib ws2_32.lib \
        /FeC:\\Python27\\DLLs\\_ssl.pyd && \
    ${WINE64}/cl.sh \
        _ssl.c \
        /LD /D_WIN32 /IC:\\Python27\\Include \
        C:\\Python27\\libs\\python27.lib \
        C:\\Python27\\libs\\libcrypto.lib \
        C:\\Python27\\libs\\libssl.lib \
        advapi32.lib crypt32.lib ws2_32.lib \
        /FeC:\\Python27\\DLLs\\_ssl.pyd && \
    rm -rf cd ${BUILDENV}/ssl

COPY patches ${BUILDENV}/patches
COPY downloads/stdint.h ${DOWNLOADS}/

RUN \
    for dir in $WINE32 $WINE64; do \
    cd $dir/drive_c && patch --binary -p0 -i ${BUILDENV}/patches/distutils.patch; done && \
    rm -rf ${BUILDENV}/patches && \
    cp -vf $DOWNLOADS/stdint.h \
    "$WINE32/drive_c/Program Files/Common Files/Microsoft/Visual C++ for Python/9.0/VC/include/" && \
    cp -vf $DOWNLOADS/stdint.h \
    "$WINE64/drive_c/Program Files (x86)/Common Files/Microsoft/Visual C++ for Python/9.0/VC/include/" && \
    rm -f $DOWNLOADS/stdint.h

RUN apt-get remove -y python-pip python-setuptools-git \
    build-essential python-dev python-wheel automake && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf ${DOWNLOADS} /root /usr/share/{doc,man,info}

RUN \
    find / -xdev ! -uid 0 -or ! -gid 0 -exec chown 0:0 '{}' ';'

ENV \
    PYTHON32=${BUILDENV}/win32/python.sh \
    PYTHON64=${BUILDENV}/win64/python.sh \
    CL32=${BUILDENV}/win32/cl.sh \
    CL64=${BUILDENV}/win64/cl.sh \
    MINGW64=x86_64-w64-mingw32-g++ \
    MINGW32=i686-w64-mingw32-g++ \
    WINEDEBUG="-all" \
    PATH=/usr/bin:/usr/sbin:/bin:/sbin:${BUILDENV}/workspace/project:${BUILDENV}/workspace/.local/bin \
    WORKSPACE=${BUILDENV}/workspace \
    PROJECT=${BUILDENV}/workspace/project

WORKDIR ${BUILDENV}/workspace/project
VOLUME ${BUILDENV}/workspace/project

LABEL maintainer "alxchk@gmail.com"
LABEL version="1.0"
LABEL description="Toolchain with wine (32/64) MSVC CL(Python) and MinGW"
