#!/bin/sh
if [ ! -z "$DOCKER_USER" ]; then
    echo '{"experimental":true}' | sudo tee /etc/docker/daemon.json
    sudo service docker restart
    docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"
fi

cd ${FOLDER}

export NAMESPACE=${TRAVIS_REPO_SLUG%%/*}

./build.sh download
./build.sh build

if [ "${TRAVIS_BRANCH}" = "master" ] && [ ! -z "$DOCKER_USER" ]; then
    ./build.sh publish
fi
