HERE=$(dirname $0)

PHPVER="${1}"
GITREV="$(git rev-parse --short HEAD)"
REPO=wearejh/php

if [ "${#PHPVER}" -lt 1 ]; then
    echo "publish.sh php-version"
    exit
fi

if [ ! -d "${PHPVER}" ]; then
    echo "PHP version ${PHPVER} not supported"
    exit
fi

docker tag $REPO:$PHPVER $REPO:$PHPVER-$GITREV

# Compare image to current before push
LAYER_DIFF=$(diff <(docker inspect $REPO:$PHPVER | jq '.[0].RootFS.Layers') <(docker inspect $REPO:$PHPVER-current | jq '.[0].RootFS.Layers'))

if [ -z "${LAYER_DIFF}" ]; then
    echo "Looks like this is exactly the same as the current build... skipping publish"
    exit
fi

docker login -u $DOCKER_USER -p $DOCKER_PASS
docker push $REPO:$PHPVER
docker push $REPO:$PHPVER-$GITREV
