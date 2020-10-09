#!/bin/sh

mkdir -p ./database-data

if [ $(docker ps -f name=blue -q) ]
then
    ENV="green"
    OLD="blue"
else
    ENV="blue"
    OLD="green"
fi

echo "Starting "$ENV" container"
docker-compose --project-name=$ENV up -d

while [ $(docker ps --filter "health=healthy" | grep $ENV | wc -l) = 0 ]
do
    sleep 5s
    echo "Waiting..."
done

echo "Container up and healthy"

echo "Stopping "$OLD" container"
docker-compose --project-name=$OLD stop
