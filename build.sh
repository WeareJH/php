HERE=$(dirname $0)

PHPVER="${1}"

if [ "${#PHPVER}" -lt 1 ]; then
    echo "build.sh php-version [tag]"
    exit
fi

if [ ! -d "${PHPVER}" ]; then
    echo "PHP version ${PHPVER} not supported"
    exit
fi

[ "${#2}" -lt 1 ] && TAG="" || TAG="-${2}"

docker build -f ${PHPVER}/Dockerfile -t wearejh/php:${PHPVER}${TAG} ${HERE}
