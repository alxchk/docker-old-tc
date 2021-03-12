#!/bin/bash

DOCKER_COMMAND=${DOCKER_COMMAND:-docker}

# ENV
SELF=$(readlink -f "$0")
SELFDIR=$(dirname "$SELF")
DOWNLOADS=${SELFDIR}/downloads

source ${SELFDIR}/versions.env
source ${SELFDIR}/urls.env

PYVER_PYTHON_ABI=${VER_PYTHON%.*}
PYVER_PYTHON_MAJ=${PYVER_PYTHON_ABI%.*}
PYVER_PYTHON_MIN=${PYVER_PYTHON_ABI#*.}
PYVER_PYTHON_REV=${VER_PYTHON##*.}

if [ ! -z "$NAMESPACE" ]; then
    NAMESPACE="${NAMESPACE}/"
fi


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
    declare -a docker_args=()

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
		      -t ${NAMESPACE}tc-windows-py${PYVER_PYTHON_MAJ} \
		      -f ${SELFDIR}/Dockerfile ${SELFDIR}
}

function publish() {
    ${DOCKER_COMMAND} push ${NAMESPACE}tc-windows-py${PYVER_PYTHON_MAJ}
}

case $1 in
    download) download ;;
    build) build ;;
    publish) publish ;;
    all) 
	echo "Downloading sources"
	download

	echo "Building windows toolchain tc-windows-py${PYVER_PYTHON_MAJ} using ${DOCKER_COMMAND}"
	build

	if [ ! -z "${NAMESPACE}" ]; then
	    echo "Publish windows toolchain as ${NAMESPACE}tc-windows-py${PYVER_PYTHON_MAJ}"
	    publish
	fi
	;;
    *)
	echo "Usage: $0 download|build|publish|all"
	exit 1
	;;
esac
