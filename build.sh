HERE=$(dirname $0)

PHPVER=

[ "$1" = "5.6" ] && PHPVER=5.6
# [ "$1" = "7.0" ] && PHPVER=7.0

if [ "${#PHPVER}" -lt 1 ]; then
    echo "build.sh 5.6 [tag=latest]"
    exit
fi

[ "${#2}" -lt 1 ] && TAG=latest || TAG=$2

docker build -f php$PHPVER.Dockerfile -t annybs/php$PHPVER-alpine:$TAG $HERE
