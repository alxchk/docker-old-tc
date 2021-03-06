#!/bin/bash

if [ -z "$ARCH" ]; then
    echo "ARCH must be set (x86/x86_64/...)"
    exit 1
fi

if [ -z "$DIST" ]; then
    echo "DIST must be set (etch/...)"
    exit 1
fi

if [ ! -z "$NAMESPACE" ]; then
    NAMESPACE="${NAMESPACE}/"
fi

case ${ARCH} in
    amd64) UNAME_ARCH="x86_64";;
    # Different from base image declaration (for cmake)
    i386) UNAME_ARCH="i386";;
    armhf) UNAME_ARCH="armv7l";;
    *) UNAME_ARCH=${ARCH};;
esac

PYMAJ=${PYMAJ:-3}

DOCKER_COMMAND=${DOCKER_COMMAND:-docker}

# ENV
SELF=$(readlink -f "$0")
SELFDIR=$(dirname "$SELF")
DOWNLOADS=${SELFDIR}/downloads

source ${SELFDIR}/versions.env
source ${SELFDIR}/py${PYMAJ}-versions.env
source ${SELFDIR}/urls.env

PYVER_PYTHON_ABI=${VER_PYTHON%.*}
PYVER_PYTHON_MAJ=${PYVER_PYTHON_ABI%.*}
PYVER_PYTHON_MIN=${PYVER_PYTHON_ABI#*.}
PYVER_PYTHON_REV=${VER_PYTHON##*.}


function download() {
    if [ ! -d ${DOWNLOADS} ]; then
	mkdir -p $DOWNLOADS
    fi
    
    for src_var in ${!SRC_*}; do
	declare -n src=${src_var}
	name=`basename "${src}"`
	dest=${DOWNLOADS}/${name}
	
	if [ -s "${dest}" ]; then
	    continue
	fi

	echo "Download ${name} (=> ${dest})"
	wget -qc "${src}" -O "${dest}" || \
	    ( rm -f "${dest}" ; echo "Failed to download ${name} from ${src}"; exit 1 )
	
	if [ ! $? -eq 0 ]; then
	    exit 1
	fi
	
    done
}


function build() {
    declare -a docker_args=(
	"--build-arg" "ARCH=${ARCH}"
	"--build-arg" "DIST=${DIST}"
	"--build-arg" "UNAME_ARCH=${UNAME_ARCH}"
	"--build-arg" "CMAKE_ARCH=${UNAME_ARCH}"
    )

    for ver_var in ${!VER_*}; do
	declare -n ver=${ver_var}
	docker_args+=(
	    "--build-arg" "${ver_var}=${ver}"
	)
    done

    for pyver_var in ${!PYVER_*}; do
	declare -n pyver=${pyver_var}
	docker_args+=(
	    "--build-arg" "${pyver_var//PYVER_}=${pyver}"
	)
    done

    if [ ! -z "${NAMESPACE}" ]; then
	docker_args+=(
	    "--build-arg" "NAMESPACE=$NAMESPACE"
	)
    fi

    echo "Args: ${docker_args[@]}"
    
    ${DOCKER_COMMAND} build --squash ${docker_args[@]} \
		      -t ${NAMESPACE}tc-linux-${ARCH}-py${PYVER_PYTHON_MAJ}:${DIST} \
		      -f ${SELFDIR}/Dockerfile ${SELFDIR}
}

function publish() {
    ${DOCKER_COMMAND} push ${NAMESPACE}tc-linux-${ARCH}-py${PYVER_PYTHON_MAJ}:${DIST}
}

case $1 in
    download) download ;;
    build) build ;;
    publish) publish ;;
    all) 
	echo "Downloading sources"
	download


	echo "Building linux toolchain tc-linux-${ARCH}-py${PYVER_PYTHON_MAJ}:${DIST} (${UNAME_ARCH}) using ${DOCKER_COMMAND}"
	build

	if [ ! -z "${NAMESPACE}" ]; then
	    echo "Publish linux toolchain as ${NAMESPACE}tc-linux-${ARCH}-py${PYVER_PYTHON_MAJ}:${DIST}"
	    publish
	fi
	;;
    *)
	echo "Usage: $0 download|build|publish|all"
	exit 1
	;;
esac
