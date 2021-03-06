HERE=$(dirname $0)

PHPVER="${1}"
REPO=wearejh/php

if [ "${#PHPVER}" -lt 1 ]; then
    echo "build.sh php-version"
    exit
fi

if [ ! -d "${PHPVER}" ]; then
    echo "PHP version ${PHPVER} not supported"
    exit
fi

docker pull ${REPO}:${PHPVER}
docker tag ${REPO}:${PHPVER} ${REPO}:${PHPVER}-current

docker build ${2} -f ${PHPVER}/Dockerfile -t ${REPO}:${PHPVER} ${HERE}
