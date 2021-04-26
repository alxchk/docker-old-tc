ARG NAMESPACE=
FROM ${NAMESPACE}debian:buster-wine

LABEL maintainer "alxchk@gmail.com"

ARG BUILDENV="/build"
ARG RCDIR="${BUILDENV}/rc-with-includes"
ARG DOWNLOADS="${BUILDENV}/downloads"
ARG WINE32="${BUILDENV}/win32"
ARG WINE64="${BUILDENV}/win64"

RUN yes | (pip install setuptools; pip install pylzma)

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
    WINEPREFIX=${WINE32} wineboot -k && \
    WINEPREFIX=${WINE32} wineserver -w && \
    WINEPREFIX=${WINE64} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -k && \
    WINEPREFIX=${WINE64} wineserver -w

RUN \
    rm -vf $WINE32/dosdevices/$DOS_DOWNLOADS && \
    rm -vf $WINE64/dosdevices/$DOS_DOWNLOADS && \
    rm -vf $WINE32/dosdevices/$DOS_RC && \
    rm -vf $WINE64/dosdevices/$DOS_RC && \
    ln -Tnvs $DOWNLOADS $WINE32/dosdevices/$DOS_DOWNLOADS && \
    ln -Tnvs $DOWNLOADS $WINE64/dosdevices/$DOS_DOWNLOADS && \
    ln -Tnvs ${RCDIR} $WINE32/dosdevices/$DOS_RC && \
    ln -Tnvs ${RCDIR} $WINE64/dosdevices/$DOS_RC

ARG VER_NASM=2.14.02

COPY \
    downloads/nasm-${VER_NASM}-win32.zip \
    downloads/nasm-${VER_NASM}-win64.zip \
        ${DOWNLOADS}/

RUN \
    cd ${WINE32}/drive_c && unzip ${DOWNLOADS}/nasm-${VER_NASM}-win32.zip && \
    cd ${WINE64}/drive_c && unzip ${DOWNLOADS}/nasm-${VER_NASM}-win64.zip && \
        rm -f ${DOWNLOADS}/nasm-${VER_NASM}-win32.zip && \
        rm -f ${DOWNLOADS}/nasm-${VER_NASM}-win64.zip

COPY \
    rc-with-includes ${RCDIR}

ARG VER_PERL=5.28.1.1

ARG PYTHON_MAJ=2
ARG PYTHON_MIN=7
ARG PYTHON_REV=8
ARG PYTHON_ABI=$PYTHON_MAJ.$PYTHON_MIN
ARG VER_PYTHON=$PYTHON_MAJ.$PYTHON_MIN.$PYTHON_REV

ENV \
    PYTHON_ABI=$PYTHON_ABI \
    VER_PYTHON=$VER_PYTHON

COPY \
    downloads/VCForPython27.msi \
    downloads/winetricks \
    downloads/python-${VER_PYTHON}.msi \
    downloads/python-${VER_PYTHON}.amd64.msi \
    downloads/strawberry-perl-${VER_PERL}-32bit.msi \
    downloads/strawberry-perl-${VER_PERL}-64bit.msi \
    ${DOWNLOADS}/

RUN \
    WINEPREFIX=${WINE32} wineserver -k ; \
    WINEPREFIX=${WINE64} wineserver -k ; \
    rm -vrf /tmp/.wine* ; \
    WINEPREFIX=${WINE32} wineboot -u && \
    WINEPREFIX=${WINE64} wineboot -u && \
    echo "Install Perl /32" && \
    WINEPREFIX=$WINE32 msiexec /i ${DOS_DOWNLOADS}\\strawberry-perl-${VER_PERL}-32bit.msi /q && \
    echo "Install Perl /64" && \
    WINEPREFIX=$WINE64 msiexec /i ${DOS_DOWNLOADS}\\strawberry-perl-${VER_PERL}-64bit.msi /q && \
    echo "Install Python /32" && \
    WINEPREFIX=$WINE32 msiexec /i $DOS_DOWNLOADS\\python-$VER_PYTHON.msi /q && \
    echo "Install Python /64" && \
    WINEPREFIX=$WINE64 msiexec /i $DOS_DOWNLOADS\\python-$VER_PYTHON.amd64.msi /q && \
    echo "Install VC /32" && \
    WINEPREFIX=$WINE32 msiexec /i $DOS_DOWNLOADS\\VCForPython27.msi /q && \
    echo "Install VC /64" && \
    WINEPREFIX=$WINE64 msiexec /i $DOS_DOWNLOADS\\VCForPython27.msi /q && \
    echo "Cleanup && winetricks" && \
        rm -f ${DOWNLOADS}/python-${VER_PYTHON}.msi \
            ${DOWNLOADS}/python-${VER_PYTHON}.amd64.msi && \
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
    rm -f  ${DOWNLOADS}/strawberry-perl-${VER_PERL}-32bit.msi \
        ${DOWNLOADS}/strawberry-perl-${VER_PERL}-64bit.msi && \
    WINEPREFIX=${WINE32} wineboot -e && \
    WINEPREFIX=${WINE64} wineboot -e && \
    WINEPREFIX=${WINE32} wineboot -f && \
    WINEPREFIX=${WINE64} wineboot -f && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s && \
    WINEPREFIX=${WINE32} wineboot -k && \
    WINEPREFIX=${WINE64} wineboot -k && \
    WINEPREFIX=${WINE32} wineserver -w && \
    WINEPREFIX=${WINE64} wineserver -w


COPY wrappers/32 ${WINE32}
COPY wrappers/64 ${WINE64}

ARG VER_OPENSSL=1.1.1g
ARG VER_OPENSSL_ABI=1_1

ARG OPENSSL_OPTIONS="shared no-async enable-static-engine no-autoload-config no-cms no-hw no-ssl2 enable-weak-ssl-ciphers no-unit-test no-filenames no-gost no-sctp no-srp no-tests no-ts no-dtls no-dtls1 no-dtls1_2 no-err no-ui"

ENV WINEPATH="C:\\nasm-${VER_NASM};C:\\Python27;C:\\Python27\\Scripts;C:\\Strawberry\\perl\\bin"

ADD \
    downloads/openssl-${VER_OPENSSL}.tar.gz ${BUILDENV}

RUN \
    cd ${BUILDENV}/openssl-${VER_OPENSSL} && \
    sed -e 's@/Zi[^"]*@@;s@/debug@@g;' -i Configurations/10-main.conf && \
    sed -e 's@|| (DEL /Q \\$(\\\@B).\* $import && EXIT 1)@@g' -i \
        Configurations/windows-makefile.tmpl && \
    MT=echo ${WINE64}/perl.sh Configure VC-WIN64A \
        --prefix=C:\\openssl-build --release $OPENSSL_OPTIONS \
            CFLAGS="/nologo /GL /Os /GF /Gy /GA" \
            LDFLAGS="/nologo /OPT:REF /OPT:ICF /LTCG" && \
    ${WINE64}/nmake.sh build_libs && \
    touch libcrypto-${VER_OPENSSL_ABI}-x64.pdb && \
    touch libssl-${VER_OPENSSL_ABI}-x64.pdb && \
    ${WINE64}/nmake.sh install_dev && \
    rm -rf ${BUILDENV}/openssl-${VER_OPENSSL} && \
    cp -vr ${WINE64}/drive_c/openssl-build/include/openssl ${WINE64}/drive_c/Python27/include/ && \
    cp -v ${WINE64}/drive_c/openssl-build/bin/*.dll ${WINE64}/drive_c/Python27 && \
    cp -v ${WINE64}/drive_c/openssl-build/lib/*.lib ${WINE64}/drive_c/Python27/libs && \
    rm -rf ${WINE64}/drive_c/openssl-build && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s && \
    WINEPREFIX=${WINE32} wineboot -k && \
    WINEPREFIX=${WINE64} wineboot -k && \
    WINEPREFIX=${WINE32} wineserver -w && \
    WINEPREFIX=${WINE64} wineserver -w

ADD \
    downloads/openssl-${VER_OPENSSL}.tar.gz ${BUILDENV}

RUN \
    cd ${BUILDENV}/openssl-${VER_OPENSSL} && \
    sed -e 's@/Zi[^"]*@@;s@/debug@@g;' -i Configurations/10-main.conf && \
    sed -e 's@|| (DEL /Q \\$(\\\@B).\* $import && EXIT 1)@@g' -i \
        Configurations/windows-makefile.tmpl && \
    MT=echo ${WINE32}/perl.sh Configure VC-WIN32 \
        --prefix=C:\\openssl-build --release $OPENSSL_OPTIONS \
            CFLAGS="/nologo /GL /Os /GF /Gy /GA" \
            LDFLAGS="/nologo /OPT:REF /OPT:ICF /LTCG" && \
    ${WINE32}/nmake.sh build_libs && \
    touch libcrypto-${VER_OPENSSL_ABI}.pdb && \
    touch libssl-${VER_OPENSSL_ABI}.pdb && \
    ${WINE32}/nmake.sh install_dev && \
    rm -rf ${BUILDENV}/openssl-${VER_OPENSSL} && \
    cp -vr ${WINE32}/drive_c/openssl-build/include/openssl ${WINE32}/drive_c/Python27/include/ && \
    cp -v ${WINE32}/drive_c/openssl-build/bin/*.dll ${WINE32}/drive_c/Python27 && \
    cp -v ${WINE32}/drive_c/openssl-build/lib/*.lib ${WINE32}/drive_c/Python27/libs && \
    rm -rf ${WINE32}/drive_c/openssl-build && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s && \
    WINEPREFIX=${WINE32} wineboot -k && \
    WINEPREFIX=${WINE64} wineboot -k && \
    WINEPREFIX=${WINE32} wineserver -w && \
    WINEPREFIX=${WINE64} wineserver -w

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
    rm -rf cd ${BUILDENV}/ssl && \
    WINEPREFIX=${WINE32} wineboot -s && \
    WINEPREFIX=${WINE64} wineboot -s && \
    WINEPREFIX=${WINE32} wineboot -k && \
    WINEPREFIX=${WINE64} wineboot -k && \
    WINEPREFIX=${WINE32} wineserver -w && \
    WINEPREFIX=${WINE64} wineserver -w

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

RUN rm -rf ${DOWNLOADS} /root /usr/share/{doc,man,info}

RUN \
    find / -xdev ! -uid 0 -or ! -gid 0 -exec chown 0:0 '{}' ';'

ENV \
    PYMAJ=$PYTHON_MAJ \
    PYMIN=$PYTHON_MIN \
    PYTHON32=${BUILDENV}/win32/python.sh \
    PYTHON64=${BUILDENV}/win64/python.sh \
    WINE_PYTHONPATH32=C:\\Python27 \
    WINE_PYTHONPATH64=C:\\Python27 \
    PYTHONPATH32=${WINE32}/drive_c/Python27 \
    PYTHONPATH64=${WINE64}/drive_c/Python27 \
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
LABEL version="1.1"
LABEL description="Toolchain with wine (32/64) MSVC CL(Python) and MinGW"
