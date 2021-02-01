#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

VERSION=$1
IMAGE_PREFIX='aae'
REGISTRY_URL='registry.gitlab.com/etalab/data.gouv.fr/infra.data.gouv.fr'

DB__WORKING_DIR='./db'
DB__APP_NAME='db'

API__WORKING_DIR='./api'
API__POSTGREST_VERSION='v7.0.1'
API__APP_NAME='api'

AIO__WORKING_DIR='./aio'
AIO__APP_NAME='aio'

echo '### building images...'
docker build \
    -t $REGISTRY_URL/$IMAGE_PREFIX-$DB__APP_NAME:$VERSION $DB__WORKING_DIR
docker build \
    --build-arg POSTGREST_VERSION=$API__POSTGREST_VERSION \
    -t $REGISTRY_URL/$IMAGE_PREFIX-$API__APP_NAME:$VERSION $API__WORKING_DIR
docker build \
    -t $REGISTRY_URL/$IMAGE_PREFIX-$AIO__APP_NAME:$VERSION $AIO__WORKING_DIR

echo '### pushing images...'
docker push $REGISTRY_URL/$IMAGE_PREFIX-$DB__APP_NAME:$VERSION
docker push $REGISTRY_URL/$IMAGE_PREFIX-$API__APP_NAME:$VERSION
docker push $REGISTRY_URL/$IMAGE_PREFIX-$AIO__APP_NAME:$VERSION
